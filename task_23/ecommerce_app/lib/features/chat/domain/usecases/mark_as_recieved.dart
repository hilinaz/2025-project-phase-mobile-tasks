import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class MarkAsRecieved extends Usecase<void, MarkAsRecievedParams> {
  final ChatRepository repository;
  MarkAsRecieved(this.repository);
  @override
  Future<Either<Failure, void>> call(MarkAsRecievedParams param) async {
    return await repository.markRecieved(param.message);
  }
}

class MarkAsRecievedParams extends Equatable {
  final Message message;
  const MarkAsRecievedParams({required this.message});

  @override
  List<Object?> get props => [message];
}
