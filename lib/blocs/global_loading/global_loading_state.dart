import 'package:equatable/equatable.dart';

class GlobalLoadingState extends Equatable {
  final bool isLoading;

  const GlobalLoadingState(this.isLoading);

  @override
  List<Object?> get props => [isLoading];
}
