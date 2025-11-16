import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Triggered when user signs in with Firebase (Google, Phone, Apple, Facebook)
class AuthLoginRequested extends AuthEvent {
  final String idToken;

  AuthLoginRequested({required this.idToken});

  @override
  List<Object?> get props => [idToken];
}

// Logout event
class AuthLogoutRequested extends AuthEvent {}
class AuthLoggedInAutomatically extends AuthEvent {
  final String refreshToken;
  AuthLoggedInAutomatically(this.refreshToken);

  @override
  List<Object?> get props => [refreshToken];
}

class AuthLoggedOut extends AuthEvent {}