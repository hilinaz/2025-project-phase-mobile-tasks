import 'package:ecommerce_app/features/auth/domain/entities/user.dart';
import 'package:equatable/equatable.dart';


abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

// Initial state before any action is taken
class AuthInitial extends AuthState {}

// State when an authentication action is in progress
class AuthLoading extends AuthState {}

// State when authentication is successful
class AuthSuccess extends AuthState {
  final User user;

  AuthSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

// State when authentication fails
class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}
