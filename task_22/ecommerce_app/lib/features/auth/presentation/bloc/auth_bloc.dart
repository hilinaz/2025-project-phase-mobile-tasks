import 'package:ecommerce_app/core/usecases/usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/login.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

import '../../domain/usecases/sign_up.dart';
import '../../domain/usecases/logout.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login signIn;
  final SignUp signUp;
  final Logout logout;

  AuthBloc({
    required this.signIn,
    required this.signUp,
    required this.logout,
  }) : super(AuthInitial()) {
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onSignInRequested(
      SignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result =
        await signIn(LoginParams(email: event.email, password: event.password));
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> _onSignUpRequested(
      SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signUp(SignUpParams(
        name: event.name, email: event.email, password: event.password));
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await logout(NoParams());
    emit(AuthInitial());
  }
}
