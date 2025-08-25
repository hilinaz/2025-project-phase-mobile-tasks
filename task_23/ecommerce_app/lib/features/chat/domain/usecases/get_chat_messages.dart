import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class GetChatMessages extends Usecase<List<Message>, GetChatMessageParams> {
  final ChatRepository repository;
  GetChatMessages(this.repository);
  @override
  Future<Either<Failure, List<Message>>> call(GetChatMessageParams param) async {
    return await repository.getChatMessages(param.chatId);
  }
}

class GetChatMessageParams extends Equatable{
  final String chatId;
  const GetChatMessageParams({required this.chatId});
  
  @override

  List<Object?> get props => [chatId];
}
