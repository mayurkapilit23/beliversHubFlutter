import 'package:equatable/equatable.dart';

abstract class GlobalLoadingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ShowLoader extends GlobalLoadingEvent {}
class HideLoader extends GlobalLoadingEvent {}
