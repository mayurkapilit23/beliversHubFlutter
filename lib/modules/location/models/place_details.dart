class PlaceDetails {
  final String name;
  final double lat;
  final double lng;

  PlaceDetails({
    required this.name,
    required this.lat,
    required this.lng,
  });

  factory PlaceDetails.fromJson(Map<String, dynamic> json) {
    final loc = json["geometry"]["location"];
    return PlaceDetails(
      name: json["name"],
      lat: loc["lat"],
      lng: loc["lng"],
    );
  }
}
