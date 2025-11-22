import 'dart:developer';

import 'package:believersHub/services/SecureStorageService.dart';

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
      await SecureStorageService.saveAuthData(
        accessToken: data["accessToken"],
        refreshToken: data["refreshToken"],
        user: data["user"],
      );
    }
    return response;
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
