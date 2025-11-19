import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/place_suggestion.dart';
import '../models/place_details.dart';

class PlaceService {
  static const String apiKey = "AIzaSyBgdvJStcOdOueLP83AcSBBnqelapxILgQ";

  static Future<List<PlaceSuggestion>> searchPlaces(String input) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey&components=country:in";

    final response = await http.get(Uri.parse(url));
    print('DASDASASDA  ${response.body}');

    if (response.statusCode == 200) {
      final predictions = jsonDecode(response.body)["predictions"] as List;

      return predictions
          .map((json) => PlaceSuggestion.fromJson(json))
          .toList();
    }

    return [];
  }

  static Future<PlaceDetails?> getPlaceDetails(String placeId) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body)["result"];
      return PlaceDetails.fromJson(result);
    }

    return null;
  }
}
