part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;
  const SignInEvent({required this.email, required this.password});

}

class SignUpEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  const SignUpEvent({required this.name,required this.email, required this.password});
}
class SignOutEvent extends AuthEvent {
  
  const SignOutEvent();
}
