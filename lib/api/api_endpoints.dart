class ApiEndpoints {
  static const String baseUrl = "http://192.168.15.168:4000";

  // Auth
  static const String loginWithFirebase = "/auth/firebase";
  static const String refreshToken = "/auth/refresh";
  static const String logout = "/auth/logout";
  static const String me = "/me";
}
