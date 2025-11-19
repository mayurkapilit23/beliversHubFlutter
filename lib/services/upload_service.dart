import 'dart:convert';
import 'package:http/http.dart' as http;
import '../features/uploadVideo/model/upload_status.dart';

class UploadService {
  static const String baseUrl = "http://10.0.2.2:4000"; // emulator
  // Change to your IP when using physical device

  static Future<UploadStatusResponse> getUploadStatus(
      String uploadId, int userId) async {
    final url = Uri.parse("$baseUrl/api/posts/upload-status/$uploadId");

    final response = await http.get(
      url,
      headers: {
        "x-user-id": userId.toString(),
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return UploadStatusResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to fetch status: ${response.body}");
    }
  }
}
