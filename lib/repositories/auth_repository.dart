import '../api/dio_client.dart';
import '../api/api_endpoints.dart';
import '../api/api_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  final DioClient _client = DioClient();
  final storage = const FlutterSecureStorage();

  Future<ApiResponse> loginWithFirebase(String idToken) async {
    final response = await _client.post(
      ApiEndpoints.loginWithFirebase,
      { "idToken": idToken },
    );

    if (response.success) {
      final data = response.data;
      await storage.write(key: "accessToken", value: data["accessToken"]);
      await storage.write(key: "refreshToken", value: data["refreshToken"]);
    }

    return response;
  }

  Future<ApiResponse> getMyProfile() {
    return _client.get(ApiEndpoints.me);
  }

  Future<ApiResponse> logout() async {
    String? refreshToken = await storage.read(key: "refreshToken");

    final response = await _client.post(
      ApiEndpoints.logout,
      { "refreshToken": refreshToken },
    );

    if (response.success) {
      await storage.delete(key: "accessToken");
      await storage.delete(key: "refreshToken");
    }

    return response;
  }
}
