class ApiEndpoints {
  // static const String baseUrl = "http://192.168.15.168:4000";//office
  static const String baseUrl = "http://192.168.31.196:4000";//home
  // static const String baseUrl = "http://172.20.10.3:4000";//iphone
  static const String uploadUrl = "https://believers-hub.s3.us-east-005.backblazeb2.com";
  // Auth
  static const String loginWithFirebase = "/auth/firebase";
  static const String refreshToken = "/auth/refresh";
  static const String logout = "/auth/logout";
  static const String me = "/me";
  static const String requestVideoUpload = "/api/posts/request-video-upload";
  static const String completeVideoUpload = "/api/posts/complete-video-upload";
  static const discardUpload = "/api/posts/discard-upload";
  static  const uploadStatus = "/api/posts/upload-status";

}
