import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../data/model/user_model.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUp signUp;
  final Login login;
  final Logout logout;
  AuthBloc({required this.signUp, required this.login, required this.logout})
      : super(AuthInitial()) {
    on<SignInEvent>(_signIn);
    on<SignUpEvent>(_signUp);
    on<SignOutEvent>(_logOut);
  }
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  Future<void> _signIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(LoadingState());
    final result =
        await login(LoginParams(email: event.email, password: event.password));
    result.fold((failure) => emit(ErrorState(message: failure.message)),
        (user) {
      emit(SignInState(
          user: UserModel(id: user.id, name: user.name, email: user.email)));
    });
  }

  Future<void> _signUp(SignUpEvent event, Emitter<AuthState> emit) async {
    if (event.name.isEmpty || event.email.isEmpty || event.password.isEmpty) {
      emit(const ErrorState(
          message: 'Please fill out all the necessary fields'));
    } else if (!emailRegex.hasMatch(event.email)) {
      emit(const ErrorState(message: 'Invalid Email'));
    } else if (event.password.length < 8) {
      emit(const ErrorState(
          message: 'Your password must contain atleast 8 characters'));
    } else {
      emit(LoadingState());
      final result = await signUp(SignupParams(
          name: event.name, email: event.email, password: event.password));
      result.fold((failure) => emit(ErrorState(message: failure.message)),
          (user) {
      
        emit(SignUpState(
            user: UserModel(id: user.id, name: user.name, email: user.email)));
      });
    }
  }

  Future<void> _logOut(SignOutEvent event, Emitter<AuthState> emit) async {
    emit(LoadingState());
    final result = await logout(const NoParams());
    result.fold((failure) => emit(ErrorState(message: failure.message)), (_) {
      emit(const SignedOutState(message: 'Log out Successfull'));
    });
  }
}
