import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(const AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);

    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthLoggedOut>(loggedOut);
    on<AuthLoggedInAutomatically>(loginAutomatically);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    final response = await authRepository.loginWithFirebase(event.idToken);

    if (response.success) {
      emit(
        state.copyWith(
          authenticated: true,
          user: response.data["user"],
          message: "Login successful",
        ),
      );
    } else {
      emit(state.copyWith(authenticated: false, message: response.message));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    final response = await authRepository.logout();

    if (response.success) {
      emit(
        state.copyWith(authenticated: false, user: null, message: "Logged out"),
      );
    } else {
      emit(state.copyWith(message: response.message));
    }
  }

  Future<void> loggedOut(AuthLoggedOut event, Emitter<AuthState> emit) async {
    emit(
      state.copyWith(authenticated: false, user: null, message: "Logged out"),
    );
  }

  Future<void> loginAutomatically(
    AuthLoggedInAutomatically event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(authenticated: true, user: null, message: "Logged in"));
  }
}
