// lib/api/dio_client.dart
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:believersHub/services/SecureStorageService.dart' show SecureStorageService;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_endpoints.dart';
import 'api_response.dart';
import 'api_exception_handler.dart';

class DioClient {
  final Dio _dio = Dio();
  CancelToken? currentUploadCancelToken; // <--- ADD THIS
  DioClient() {
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);

    // 1) Request interceptor to inject access token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            if (options.extra["skipAuth"] == true) {
              return handler.next(options);
            }
            String? accessToken = await SecureStorageService.getAccessToken();
            print("Token = $accessToken");
            if (accessToken != null) {
              options.headers["authorization"] = "Bearer $accessToken";
            }
          } catch (_) {
            // ignore reading errors; proceed without token
          }
          return handler.next(options);
        },
      ),
    );

    // 2) Logging interceptor (safe: redacts Authorization). Only active in debug.
    _dio.interceptors.add(_SafeLoggingInterceptor());

    // 3) Error interceptor to attempt refresh + retry on 401
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          // Only attempt refresh if response exists and status is 401
          final resp = error.response;
          if (resp?.statusCode == 401) {
            final refreshed = await _refreshToken();
            if (refreshed) {
              // retry original request with new tokens
              final req = error.requestOptions;
              try {
                // create new options to avoid modifying original
                final opts = Options(
                  method: req.method,
                  headers: req.headers,
                  responseType: req.responseType,
                  contentType: req.contentType,
                  followRedirects: req.followRedirects,
                  validateStatus: req.validateStatus,
                  receiveDataWhenStatusError: req.receiveDataWhenStatusError,
                );

                // Retrying - ensure Authorization header is updated by request interceptor
                final response = await _dio.request(
                  req.path,
                  data: req.data,
                  queryParameters: req.queryParameters,
                  options: opts,
                );
                return handler.resolve(response);
              } catch (e) {
                // fallthrough to original error
              }
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  // ===== Refresh token logic =====
  Future<bool> _refreshToken() async {
    _dio.options.baseUrl = ApiEndpoints.baseUrl;

    String? refreshToken = await SecureStorageService.getRefreshToken();
    ();

    // String? refreshToken = await storage.read(key: "refreshToken");
    if (refreshToken == null) return false;

    try {
      final response = await _dio.post(
        ApiEndpoints.refreshToken,
        data: {"refreshToken": refreshToken},
      );

      final data = response.data;

      if (data == null) return false;
      SecureStorageService.saveTokens(
        accessToken: data["accessToken"],
        refreshToken: data["refreshToken"],
      );

      // await storage.write(key: "accessToken", value: data["accessToken"]);
      // await storage.write(key: "refreshToken", value: data["refreshToken"]);

      return true;
    } catch (_) {
      SecureStorageService.deleteTokens();
      return false;
    }
  }

  // ===== GET =====
  Future<ApiResponse> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    _dio.options.baseUrl = ApiEndpoints.baseUrl;

    try {
      final response = await _dio.get(endpoint, queryParameters: queryParameters);
      return ApiResponse.success(response.data);
    } catch (e) {
      return ApiResponse.error(ApiExceptionHandler.getErrorMessage(e));
    }
  }

  // ===== POST =====
  Future<ApiResponse> post(String endpoint, Map<String, dynamic> data) async {
    _dio.options.baseUrl = ApiEndpoints.baseUrl;

    try {
      final response = await _dio.post(endpoint, data: data, );
      return ApiResponse.success(response.data,);
    } catch (e) {
      return ApiResponse.error(ApiExceptionHandler.getErrorMessage(e));
    }
  }

  Future<ApiResponse> delete(String endpoint, Map<String, dynamic> data) async {
    _dio.options.baseUrl = ApiEndpoints.baseUrl;

    try {
      final response = await _dio.delete(endpoint, data: data, );
      return ApiResponse.success(response.data,);
    } catch (e) {
      return ApiResponse.error(ApiExceptionHandler.getErrorMessage(e));
    }
  }

  Future<ApiResponse> put(String presignedUrl, File file, Function(double) onProgress) async {
    final cancelToken = CancelToken();
    currentUploadCancelToken = cancelToken;
    try {
      final length = await file.length();
      final stream = file.openRead();
     final uploadUrl= removeBaseUrl(presignedUrl, ApiEndpoints.uploadUrl);
      _dio.options.baseUrl= ApiEndpoints.uploadUrl;
      final response = await _dio.put(
        cancelToken: cancelToken,
        uploadUrl,
        data: stream,
        options: Options(
          headers: {
            "Content-Type": "video/mp4",
            Headers.contentLengthHeader: length,
          },
          extra: {"skipAuth": true},  // <-- prevent token injection
          responseType: ResponseType.plain, // avoid JSON parsing errors
        ),
        onSendProgress: (sent, total) {
          if (total > 0) {
            final progress = sent / total;
            onProgress(progress);
          }
        },
      );

      // Backblaze S3 returns 200 or 204 for successful upload
      if (response.statusCode == 200 || response.statusCode == 204) {
        return ApiResponse.success(null, message: "Uploaded");
      }

      return ApiResponse.error("Upload failed: ${response.statusMessage}");
    } catch (e) {
      if(CancelToken.isCancel(DioException(error: e, requestOptions: RequestOptions()))) {
        return ApiResponse.error("Upload canceled");
      }
      return ApiResponse.error(e.toString());
    }
  }
}

String removeBaseUrl(String url, String baseUrl) {
  return url.replaceFirst(baseUrl, '');
}

/// Safe logging interceptor:
/// - Active only in debug mode
/// - Redacts Authorization header value
class _SafeLoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      final safeHeaders = Map<String, dynamic>.from(options.headers);
      if (safeHeaders.containsKey('Authorization')) {
        safeHeaders['Authorization'] = 'REDACTED';
      }
      final prettyRequest = StringBuffer();
      prettyRequest.writeln(
        '*** API Request → ${options.method} ${options.baseUrl}${options.path}',
      );
      prettyRequest.writeln('Headers: ${_formatMap(safeHeaders)}');
      if (options.queryParameters.isNotEmpty) {
        prettyRequest.writeln('Query: ${_formatMap(options.queryParameters)}');
      }
      if (options.data != null) {
        try {
          prettyRequest.writeln('Body: ${_safeStringify(options.data)}');
        } catch (_) {
          prettyRequest.writeln('Body: <non-serializable>');
        }
      }
      debugPrint(prettyRequest.toString());
    }
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      final prettyResponse = StringBuffer();
      prettyResponse.writeln(
        '*** API Response ← ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.baseUrl}${response.requestOptions.path}',
      );
      prettyResponse.writeln('Duration: ${response.extra['duration'] ?? 'n/a'}');
      try {
        prettyResponse.writeln('Response: ${_safeStringify(response.data)}');
      } catch (_) {
        prettyResponse.writeln('Response: <non-serializable>');
      }
      debugPrint(prettyResponse.toString());
    }
    return handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      final prettyError = StringBuffer();
      final req = err.requestOptions;
      prettyError.writeln(
        '*** API Error ← ${err.response?.statusCode ?? 'NO_STATUS'} ${req.method} ${req.baseUrl}${req.path}',
      );
      if (err.response?.data != null) {
        try {
          prettyError.writeln('Error Data: ${_safeStringify(err.response?.data)}');
        } catch (_) {
          prettyError.writeln('Error Data: <non-serializable>');
        }
      } else {
        prettyError.writeln('Error: ${err.message}');
      }
      debugPrint(prettyError.toString());
    }
    return handler.next(err);
  }

  String _formatMap(Map m) => const JsonEncoder.withIndent('  ').convert(m);

  String _safeStringify(dynamic data) {
    if (data is String) return data;
    try {
      return const JsonEncoder.withIndent('  ').convert(data);
    } catch (_) {
      return data.toString();
    }
  }
}
