import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/chat_repository.dart';

class DeleteChat extends Usecase<void, DeleteChatParams> {
  final ChatRepository repository;
  DeleteChat(this.repository);
  @override
  Future<Either<Failure, void>> call(DeleteChatParams param) async {
    return await repository.deleteChat(param.chatId);
  }
}

class DeleteChatParams extends Equatable {
  final String chatId;
  const DeleteChatParams({required this.chatId});

  @override
  List<Object?> get props => [chatId];
}
