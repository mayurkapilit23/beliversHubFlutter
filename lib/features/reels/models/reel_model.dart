class ReelModel {
  final String id;
  final String mediaUrl;
  final String thumbnailUrl;
  final String caption;
  final List<String> hashtags;
  final String location;
  final double score;

  ReelModel({
    required this.id,
    required this.mediaUrl,
    required this.thumbnailUrl,
    required this.caption,
    required this.hashtags,
    required this.location,
    required this.score,
  });

  factory ReelModel.fromJson(Map<String, dynamic> json) {
    return ReelModel(
      id: json["id"],
      mediaUrl: json["media_url"],
      thumbnailUrl: json["thumbnail_url"] ?? "",
      caption: json["caption"] ?? "",
      hashtags: json["hashtags"] != null
          ? List<String>.from(json["hashtags"])
          : [],
      location: json["location"] ?? "",
      score: (json["score"] ?? 0).toDouble(),
    );
  }
}
