import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  final bool authenticated;
  final String? message; // for success / error messages
  final Map<String, dynamic>? user;

  const AuthState({this.authenticated = false, this.message, this.user});

  AuthState copyWith({
    bool? authenticated,
    String? message,
    Map<String, dynamic>? user,
  }) {
    return AuthState(
      authenticated: authenticated ?? this.authenticated,
      message: message,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [authenticated, message ?? "", user ?? {}];
}

// Initial state
class AuthInitial extends AuthState {
  const AuthInitial() : super(authenticated: false);
}
class OtpSent extends AuthState {
  final String verificationId;
  const OtpSent(this.verificationId);
}

class PhoneAuthLoading extends AuthState {
  const PhoneAuthLoading();
}

class PhoneAuthError extends AuthState {
  final String error;
  const PhoneAuthError(this.error);
}

class PhoneAuthSuccess extends AuthState {
  const PhoneAuthSuccess();
}

