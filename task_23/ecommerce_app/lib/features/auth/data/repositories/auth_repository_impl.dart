
import 'package:dartz/dartz.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';


class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDatasource localDatasource;
  final AuthRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;
  AuthRepositoryImpl(
      this.localDatasource, this.remoteDatasource, this.networkInfo);
  @override
  Future<Either<Failure, User>> logIn(String email, String password) async {
   if (await networkInfo.isConnected) {
      try {
        final User = await remoteDatasource.logIn(email, password);
       
        await localDatasource.cacheUser(User);
        return Right(User);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logOut() async {
    if (await networkInfo.isConnected) {
      try {
        await localDatasource.clearUser();
        await localDatasource.clearToken();

        return Right(await remoteDatasource.logOut());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> signUp(
      String name, String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final userModel = await remoteDatasource.signUp(name, email, password);
        await localDatasource.cacheUser(userModel);
        return Right(userModel);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }
}
