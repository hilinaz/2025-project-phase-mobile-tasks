

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/chat.dart';
import '../repositories/chat_repository.dart';

class GetMyChats extends Usecase<List<Chat>, NoParams> {
  final ChatRepository repository;
  GetMyChats(this.repository);
  @override
  Future<Either<Failure, List<Chat>>> call(NoParams param) async {
    return await repository.getMyChats();
  }
}

