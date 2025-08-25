import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

import '../entities/chat.dart';

import '../repositories/chat_repository.dart';

class InitChat extends Usecase<Chat, InitChatParams> {
  final ChatRepository repository;
  InitChat(this.repository);
  @override
  Future<Either<Failure, Chat>> call(InitChatParams param) async {
    return await repository.initChat(param.userId);
  }
}

class InitChatParams extends Equatable {
  final String userId;
  const InitChatParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}
