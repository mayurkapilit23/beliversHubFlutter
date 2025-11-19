import 'package:flutter_bloc/flutter_bloc.dart';
import 'location_event.dart';
import 'location_state.dart';
import '../data/place_service.dart';
import '../data/location_service.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationState()) {
    on<SearchLocationEvent>(_onSearch);
    on<SelectSuggestionEvent>(_onSelectSuggestion);
    on<SelectCurrentLocationEvent>(_onSelectCurrent);
  }

  Future<void> _onSearch(
      SearchLocationEvent event, Emitter<LocationState> emit) async {
    if (event.query.isEmpty) {
      emit(state.copyWith(suggestions: []));
      return;
    }

    emit(state.copyWith(loading: true));
    final results = await PlaceService.searchPlaces(event.query);
    emit(state.copyWith(loading: false, suggestions: results));
  }

  Future<void> _onSelectSuggestion(
      SelectSuggestionEvent event, Emitter<LocationState> emit) async {
    emit(state.copyWith(loading: true));
    final details = await PlaceService.getPlaceDetails(event.placeId);
    emit(state.copyWith(loading: false, selectedPlace: details));
  }

  Future<void> _onSelectCurrent(SelectCurrentLocationEvent event, Emitter<LocationState> emit) async {
    emit(state.copyWith(loading: true));
    final loc = await LocationService.getCurrentLocation();
    emit(state.copyWith(loading: false, selectedPlace: loc));
  }
}
