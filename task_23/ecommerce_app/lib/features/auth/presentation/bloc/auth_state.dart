part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

class ErrorState extends AuthState {
  final String message;
  const ErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class LoadingState extends AuthState {}

class SignInState extends AuthState {
  final User user;
  const SignInState({required this.user});
  @override
  List<Object> get props => [user];
}

class SignUpState extends AuthState {
  final User user;
  const SignUpState({required this.user});
  @override
  List<Object> get props => [user];
}

class SignedOutState extends AuthState {
  final String message;
  const SignedOutState({required this.message});
}
