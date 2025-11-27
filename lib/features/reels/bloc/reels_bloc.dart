import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:believersHub/features/reels/ReelsRepository.dart';
import './reels_event.dart';
import './reels_state.dart';
import '../models/reel_model.dart';

class ReelsBloc extends Bloc<ReelsEvent, ReelsState> {
  final ReelsRepository repo;

  ReelsBloc(this.repo) : super(ReelsInitial()) {
    on<LoadReelsEvent>(_onLoadReels);
  }

  Future<void> _onLoadReels(
      LoadReelsEvent event,
      Emitter<ReelsState> emit,
      ) async {
    emit(ReelsLoading());

    final response = await repo.getReels(
      interests: event.interests,
      location: event.location,
    );

    if (!response.success) {
      emit(ReelsError(response.message ?? "Failed"));
      return;
    }

    // response.data is dynamic, cast it
    final list = (response.data["data"] as List)
        .map((e) => ReelModel.fromJson(e))
        .toList();

    emit(ReelsLoaded(list));
  }
}
