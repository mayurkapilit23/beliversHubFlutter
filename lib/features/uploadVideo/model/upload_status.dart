class UploadStatusResponse {
  final String status;
  final MediaData? media;

  UploadStatusResponse({required this.status, this.media});

  factory UploadStatusResponse.fromJson(Map<String, dynamic> json) {
    return UploadStatusResponse(
      status: json["status"],
      media: json["media"] != null ? MediaData.fromJson(json["media"]) : null,
    );
  }
}

class MediaData {
  final int id;
  final int durationSec;
  final int width;
  final int height;
  final List<MediaVariant> variants;
  final List<ThumbnailData> thumbnails;

  MediaData({
    required this.id,
    required this.durationSec,
    required this.width,
    required this.height,
    required this.variants,
    required this.thumbnails,
  });

  factory MediaData.fromJson(Map<String, dynamic> json) {
    return MediaData(
      id: json["id"],
      durationSec: json["duration_sec"],
      width: json["width"],
      height: json["height"],
      variants: (json["variants"] as List<dynamic>)
          .map((v) => MediaVariant.fromJson(v))
          .toList(),
      thumbnails: (json["thumbnails"] as List<dynamic>)
          .map((t) => ThumbnailData.fromJson(t))
          .toList(),
    );
  }
}

class MediaVariant {
  final int id;
  final String quality;
  final String url;
  final int sizeBytes;

  MediaVariant({
    required this.id,
    required this.quality,
    required this.url,
    required this.sizeBytes,
  });

  factory MediaVariant.fromJson(Map<String, dynamic> json) {
    return MediaVariant(
      id: json["id"],
      quality: json["quality"],
      url: json["url"],
      sizeBytes: json["size_bytes"],
    );
  }
}

class ThumbnailData {
  final int id;
  final String url;
  final bool isSelected;

  ThumbnailData({
    required this.id,
    required this.url,
    required this.isSelected,
  });

  factory ThumbnailData.fromJson(Map<String, dynamic> json) {
    return ThumbnailData(
      id: json["id"],
      url: json["url"],
      isSelected: json["is_selected"],
    );
  }
}
