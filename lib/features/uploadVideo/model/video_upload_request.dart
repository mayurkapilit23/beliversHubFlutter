class VideoUploadRequest {
  final String filename;
  final String contentType;
  final int fileSize;

  VideoUploadRequest({
    required this.filename,
    required this.contentType,
    required this.fileSize,
  });

  Map<String, dynamic> toJson() {
    return {
      'filename': filename,
      'contentType': contentType,
      'fileSize': fileSize,
    };
  }
}
