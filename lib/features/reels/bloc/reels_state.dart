import 'package:equatable/equatable.dart';
import '../models/reel_model.dart';

abstract class ReelsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReelsInitial extends ReelsState {}

class ReelsLoading extends ReelsState {}

class ReelsLoaded extends ReelsState {
  final List<ReelModel> reels;
  ReelsLoaded(this.reels);

  @override
  List<Object?> get props => [reels];
}

class ReelsError extends ReelsState {
  final String message;
  ReelsError(this.message);

  @override
  List<Object?> get props => [message];
}
