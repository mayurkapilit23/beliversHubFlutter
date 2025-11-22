class VideoUploadResponse {
  final String uploadId;
  final String fileKey;
  final String uploadUrl;
  final int expiresIn;

  VideoUploadResponse({
    required this.uploadId,
    required this.fileKey,
    required this.uploadUrl,
    required this.expiresIn,
  });

  factory VideoUploadResponse.fromJson(Map<String, dynamic> json) {
    return VideoUploadResponse(
      uploadId: json['uploadId'],
      fileKey: json['fileKey'],
      uploadUrl: json['uploadUrl'],
      expiresIn: json['expiresIn'],
    );
  }
}