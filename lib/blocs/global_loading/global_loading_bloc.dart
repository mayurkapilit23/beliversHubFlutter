import 'package:flutter_bloc/flutter_bloc.dart';
import 'global_loading_event.dart';
import 'global_loading_state.dart';

class GlobalLoadingBloc extends Bloc<GlobalLoadingEvent, GlobalLoadingState> {
  GlobalLoadingBloc() : super(const GlobalLoadingState(false)) {
    on<ShowLoader>((event, emit) => emit(const GlobalLoadingState(true)));
    on<HideLoader>((event, emit) => emit(const GlobalLoadingState(false)));
  }
}
