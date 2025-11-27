import 'package:believersHub/api/dio_client.dart';
import 'package:believersHub/api/api_endpoints.dart';

class UserInterestsApi {
  final DioClient _dio = DioClient();

  Future<Map<String, double>> getUserInterests(String userId) async {
    final res = await _dio.get("${ApiEndpoints.userInterests}/$userId");

    if (!res.success) return {};

    final data = res.data["interests"] as Map<String, dynamic>;
    return data.map((k, v) => MapEntry(k, (v as num).toDouble()));
  }
}
