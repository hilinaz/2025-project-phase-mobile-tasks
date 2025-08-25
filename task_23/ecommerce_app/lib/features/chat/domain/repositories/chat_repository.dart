import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../auth/domain/entities/user.dart';

import '../entities/chat.dart';
import '../entities/message.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<Chat>>> getMyChats();
  Future<Either<Failure, Chat>> getChatById(String id);
  Future<Either<Failure, List<Message>>> getChatMessages(String chatId);
  Future<Either<Failure, Chat>> initChat(String userId);
  Future<Either<Failure, void>> deleteChat(String chatId);
   

   Future<Either<Failure, List<User>>> getAllUsers();
   Future<Either<Failure, void>> sendMessage(String ChatId,String type,String Content);
   Future<Either<Failure, void>> markRecieved(Message message);
   Stream<Message> onMessageReceived();










}
