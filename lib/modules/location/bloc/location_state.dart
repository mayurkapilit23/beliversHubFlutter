import '../models/place_suggestion.dart';
import '../models/place_details.dart';

class LocationState {
  final bool loading;
  final List<PlaceSuggestion> suggestions;
  final PlaceDetails? selectedPlace;
  final String? message;

  LocationState({
    this.loading = false,
    this.suggestions = const [],
    this.selectedPlace,
    this.message,
  });

  LocationState copyWith({
    bool? loading,
    List<PlaceSuggestion>? suggestions,
    PlaceDetails? selectedPlace,
    String? message,
  }) {
    return LocationState(
      loading: loading ?? this.loading,
      suggestions: suggestions ?? this.suggestions,
      selectedPlace: selectedPlace,
      message: message,
    );
  }
}
