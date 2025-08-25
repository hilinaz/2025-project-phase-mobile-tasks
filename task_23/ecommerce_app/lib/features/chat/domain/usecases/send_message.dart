import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

import '../repositories/chat_repository.dart';

class SendMessage extends Usecase<void, SendMessageParams> {
  final ChatRepository repository;
  SendMessage(this.repository);
  @override
  Future<Either<Failure, void>> call(SendMessageParams param) async {
    return await repository.sendMessage(param.Content,param.type,param.ChatId);
  }
}

class SendMessageParams extends Equatable {
  final String ChatId;
  final String type;
  final String Content;
  const SendMessageParams({required this.ChatId,required this.Content,required this.type});

  @override
  List<Object?> get props => [ChatId,Content,type];
}
