import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../auth/domain/entities/user.dart';

import '../repositories/chat_repository.dart';

class GetAllUser extends Usecase<List<User>, NoParams> {
  final ChatRepository repository;
 GetAllUser(this.repository);
  @override
  Future<Either<Failure, List<User>>> call(NoParams param) async {
    return await repository.getAllUsers();
  }
}
