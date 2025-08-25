import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/chat.dart';
import '../repositories/chat_repository.dart';

class GetChatById extends Usecase<Chat, GetChatParams> {
  final ChatRepository repository;
  GetChatById(this.repository);
  @override
  Future<Either<Failure, Chat>> call(GetChatParams param) async {
    return await repository.getChatById(param.chatId);
  }
}

class GetChatParams extends Equatable {
  final String chatId;
  const GetChatParams({required this.chatId});

  @override
  List<Object?> get props => [chatId];
}
