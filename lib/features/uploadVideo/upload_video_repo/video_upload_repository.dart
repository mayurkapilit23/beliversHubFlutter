import 'dart:developer';
import 'dart:io';

import 'package:believersHub/features/uploadVideo/model/VideoProcessingResponse.dart';
import 'package:believersHub/features/uploadVideo/model/video_upload_request.dart';
import 'package:believersHub/features/uploadVideo/model/video_upload_response.dart';

import '../../../api/dio_client.dart';
import '../../../api/api_endpoints.dart';
import '../../../api/api_response.dart';

class VideoUploadRepository {
  final DioClient _client = DioClient();

  Future<ApiResponse> requestVideoUpload(VideoUploadRequest videoUploadRequest) async {
    final response = await _client.post(
      ApiEndpoints.requestVideoUpload,
      videoUploadRequest.toJson(),
    );
    if (response.success) {
      final data = response.data;
      final apiResponse = ApiResponse(
        success: true,
        data: VideoUploadResponse.fromJson(data),
        message: "Video upload request sent successfully",
      );
      return apiResponse;
    } else {
      final apiResponse = ApiResponse(
        success: false,
        data: null,
        message: "Video upload request failed",
      );
      return apiResponse;
    }
  }
  Future<void> cancelUpload() async {
    _client.currentUploadCancelToken?.cancel("User canceled upload");
  }
  Future<ApiResponse> discardUpload(String uploadId) async {
    return await _client.delete(ApiEndpoints.discardUpload, {
      "uploadId": uploadId,
    });
  }

  Future<ApiResponse> uploadToS3(
      String presignedUrl,
      File file,
      Function(double progress) onProgress,
      ) async {
    final response = await _client.put(presignedUrl, file, onProgress);

    if (response.success) {
      return ApiResponse(
        success: true,
        data: null,
        message: "Video uploaded successfully",
      );
    } else {
      return ApiResponse(
        success: false,
        data: null,
        message: "Video upload failed",
      );
    }
  }

  Future<ApiResponse> completeVideoUpload(String uploadId, String fileKey) async {
    final response = await _client.post(ApiEndpoints.completeVideoUpload, {
      "uploadId": uploadId,
      "fileKey": fileKey,
    });
    if (response.success) {
      final data = response.data;
      return ApiResponse(
        success: true,
        data: VideoProcessingResponse.fromJson(data),
        message: "Processing Video Request sent successfully",
      );
    } else {
      return ApiResponse(success: false, data: null, message: "Video Processing failed");
    }
  }
}
