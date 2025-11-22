class VideoProcessingResponse {
  final bool ok;
  final String message;

  VideoProcessingResponse({
    required this.ok,
    required this.message,
  });

  factory VideoProcessingResponse.fromJson(Map<String, dynamic> json) {
    return VideoProcessingResponse(
      ok: json['ok'],
      message: json['message'],
    );
  }
}