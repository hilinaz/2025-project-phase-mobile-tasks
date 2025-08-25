part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class LoadAllChatsEvent extends ChatEvent {}
class GetAllUsersEvent extends ChatEvent {}

class LoadSingleChatEvent extends ChatEvent {
  final String chatId;
  const LoadSingleChatEvent({required this.chatId});
}

class LoadChatMessageEvent extends ChatEvent {
  final String chatId;
  const LoadChatMessageEvent({required this.chatId});
}

class InitiateNewChatEvent extends ChatEvent {
  final String userId;
  const InitiateNewChatEvent({required this.userId});
}

class DeleteChatEvent extends ChatEvent {
  final String chatId;
  const DeleteChatEvent({required this.chatId});
}

class SendMessageEvent extends ChatEvent {
  final String ChatId;
  final String Content;
  final String type;
  const SendMessageEvent(
      {required this.ChatId, required this.Content, required this.type});
}

class MessageReceivedEvent extends ChatEvent {
  final Message message;
  const MessageReceivedEvent({required this.message});
}

class MarkMessageReceivedEvent extends ChatEvent {
  final Message message;
  const MarkMessageReceivedEvent({required this.message});
}

class RetryLoadChatsEvent extends ChatEvent {}

class RetryLoadMessagesEvent extends ChatEvent {
  final String chatId;
  const RetryLoadMessagesEvent({required this.chatId});
}
