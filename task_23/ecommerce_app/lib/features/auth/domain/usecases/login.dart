import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class Login extends Usecase<User, LoginParams> {
  final AuthRepository repository;
  Login(this.repository);
  @override
  Future<Either<Failure, User>> call(LoginParams param) async {
    return await repository.logIn(param.email, param.password);
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;
  const LoginParams({required this.email, required this.password});
  @override

  List<Object?> get props => [email, password];
}
