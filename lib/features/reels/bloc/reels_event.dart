import 'package:equatable/equatable.dart';

abstract class ReelsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadReelsEvent extends ReelsEvent {
  final List<String> interests;
  final String? location;

  LoadReelsEvent({
    this.interests = const [],
    this.location,
  });
}
