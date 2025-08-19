import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignUp extends Usecase<User, SignupParams> {
  final AuthRepository repository;
  SignUp(this.repository);
  @override
  Future<Either<Failure, User>> call(SignupParams param) async {
    return await repository.signUp(param.name, param.email, param.password);
  }
}

class SignupParams extends Equatable {
  final String name;
  final String email;
  final String password;
  const SignupParams(
      {required this.name, required this.email, required this.password});

  @override
 
  List<Object?> get props => [name, email, password];
}
