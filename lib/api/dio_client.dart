// lib/api/dio_client.dart
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_endpoints.dart';
import 'api_response.dart';
import 'api_exception_handler.dart';

class DioClient {
  final Dio _dio = Dio();
  final storage = const FlutterSecureStorage();

  DioClient() {
    _dio.options.baseUrl = ApiEndpoints.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);

    // 1) Request interceptor to inject access token
    _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
      try {
        String? accessToken = await storage.read(key: "accessToken");
        if (accessToken != null) {
          options.headers["Authorization"] = "Bearer $accessToken";
        }
      } catch (_) {
        // ignore reading errors; proceed without token
      }
      return handler.next(options);
    }));

    // 2) Logging interceptor (safe: redacts Authorization). Only active in debug.
    _dio.interceptors.add(_SafeLoggingInterceptor());

    // 3) Error interceptor to attempt refresh + retry on 401
    _dio.interceptors.add(InterceptorsWrapper(onError: (error, handler) async {
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
    }));
  }

  // ===== Refresh token logic =====
  Future<bool> _refreshToken() async {
    String? refreshToken = await storage.read(key: "refreshToken");
    if (refreshToken == null) return false;

    try {
      final response = await _dio.post(ApiEndpoints.refreshToken, data: {
        "refreshToken": refreshToken,
      });

      final data = response.data;
      if (data == null) return false;
      await storage.write(key: "accessToken", value: data["accessToken"]);
      await storage.write(key: "refreshToken", value: data["refreshToken"]);

      return true;
    } catch (_) {
      // if refresh fails, clear tokens to force re-login flow
      await storage.delete(key: "accessToken");
      await storage.delete(key: "refreshToken");
      return false;
    }
  }

  // ===== GET =====
  Future<ApiResponse> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return ApiResponse.success(response.data);
    } catch (e) {
      return ApiResponse.error(ApiExceptionHandler.getErrorMessage(e));
    }
  }

  // ===== POST =====
  Future<ApiResponse> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return ApiResponse.success(response.data);
    } catch (e) {
      return ApiResponse.error(ApiExceptionHandler.getErrorMessage(e));
    }
  }
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
      prettyRequest.writeln('*** API Request → ${options.method} ${options.baseUrl}${options.path}');
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
      prettyResponse.writeln('*** API Response ← ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.baseUrl}${response.requestOptions.path}');
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
      prettyError.writeln('*** API Error ← ${err.response?.statusCode ?? 'NO_STATUS'} ${req.method} ${req.baseUrl}${req.path}');
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
