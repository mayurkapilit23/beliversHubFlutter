import 'package:believersHub/api/dio_client.dart';
import 'package:believersHub/api/api_endpoints.dart';

class WatchTimeService {
  final DioClient _dio = DioClient();

  Future<void> sendWatchTime({
    required String userId,
    required String postId,
    required int seconds,
  }) async {
    final payload = {
      "userId": userId,
      "postId": postId,
      "watchedSeconds": seconds,
    };

    final response = await _dio.post(
      ApiEndpoints.watchTime, // you must add this endpoint
      payload,
    );

    if (!response.success) {
      print("❌ Watch time failed: ${response.message}");
    } else {
      print("Watch time sent: $seconds seconds");
    }
  }
}
