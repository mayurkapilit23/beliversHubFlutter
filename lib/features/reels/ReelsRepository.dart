
import 'package:believersHub/api/api_endpoints.dart';
import 'package:believersHub/api/api_response.dart';
import 'package:believersHub/api/dio_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' show FlutterSecureStorage;


class ReelsRepository {
  final DioClient _client = DioClient();
  final storage = const FlutterSecureStorage();

  Future<ApiResponse> getReels({
    List<String> interests = const [],
    String? location,
  }) async{
    final queryParams = {
      "limit": "20",
      if (interests.isNotEmpty)
        "interests": interests.join(","),
      if (location != null)
        "location": location,
    };
    final response = await _client.get(ApiEndpoints.reels, queryParameters: queryParams,);
    if (response.success) {
      return ApiResponse(
        success: true,
        data: response.data,
        message: "",
      );
    } else {
      return ApiResponse(
        success: false,
        data: null,
        message: "Failed to fetch reels",
      );
    }
  }
}
