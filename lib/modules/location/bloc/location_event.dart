abstract class LocationEvent {}

class SearchLocationEvent extends LocationEvent {
  final String query;
  SearchLocationEvent(this.query);
}

class SelectSuggestionEvent extends LocationEvent {
  final String placeId;
  SelectSuggestionEvent(this.placeId);
}

class SelectCurrentLocationEvent extends LocationEvent {}
