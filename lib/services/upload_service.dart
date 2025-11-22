import 'dart:convert';
import 'package:believersHub/api/api_endpoints.dart';
import 'package:believersHub/api/dio_client.dart';
import 'package:http/http.dart' as http;
import '../features/uploadVideo/model/upload_status.dart';

class UploadService {
  static Future<UploadStatusResponse> getUploadStatus(String uploadId) async {
    final DioClient _client = DioClient();

    final response = await _client.get(ApiEndpoints.uploadStatus,queryParameters: {"uploadId":uploadId});
    if (response.success) {
      return UploadStatusResponse.fromJson(response.data);
    } else {
      throw Exception("Failed to fetch status: ${response.message}");
    }
  }
}
