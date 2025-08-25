import 'package:dartz/dartz.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../auth/domain/entities/user.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_local_datasources.dart';
import '../datasources/chat_remote_datasources.dart';
import '../datasources/chat_socket_datasources.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatLocalDatasources localDatasource;
  final ChatRemoteDatasources remoteDatasource;
  final ChatSocketDatasources socketDatasources;
  final NetworkInfo networkInfo;

  ChatRepositoryImpl({
    required this.localDatasource,
    required this.remoteDatasource,
    required this.socketDatasources,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, List<User>>> getAllUsers() async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await remoteDatasource.getAllUsers());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Chat>> getChatById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final chat = await remoteDatasource.getChatById(id);

        return Right(chat);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getChatMessages(String chatId) async {
    if (await networkInfo.isConnected) {
      try {
        final messageList = await remoteDatasource.getChatMessages(chatId);
        await localDatasource.cacheMessages(chatId, messageList);
        return Right(messageList);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        return Right(await localDatasource.getCachedMessages(chatId));
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<Chat>>> getMyChats() async {
    if (await networkInfo.isConnected) {
      try {
        final chatList = await remoteDatasource.getMyChats();
        await localDatasource.cacheChats(chatList);
        return Right(chatList);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        return Right(await localDatasource.getCachedChats());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, ChatModel>> initChat(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await remoteDatasource.initChat(userId));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> markRecieved(Message message) async {
    if (await networkInfo.isConnected) {
      try {
        final messageModel = MessageModel.fromEntity(message);
        socketDatasources.markReceived(messageModel);
        return const Right(null);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Stream<Message> onMessageReceived() async* {
    if (await networkInfo.isConnected) {
      try {
        yield* socketDatasources.onMessageReceived();
      } on ServerException {
        yield* Stream.error(ServerFailure());
      }
    } else {
      yield* Stream.error(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage(String ChatId,String type,String Content) async {
    if (await networkInfo.isConnected) {
      try {
     
        socketDatasources.sendMessage(ChatId,type,Content);
        return const Right(null);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteChat(String chatId) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await remoteDatasource.deleteChat(chatId));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }
}
