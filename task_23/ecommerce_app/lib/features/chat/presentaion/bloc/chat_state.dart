part of 'chat_bloc.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

final class ChatInitial extends ChatState {}

class LoadingState extends ChatState {}

class LoadedChatsState extends ChatState {
  final List<ChatModel> chats;
  const LoadedChatsState({required this.chats});
}
class LoadedAllUsersState extends ChatState {
  final List<UserModel> users;
  const LoadedAllUsersState({required this.users});
}

class LoadedChatState extends ChatState {
  final ChatModel chat;
  const LoadedChatState({required this.chat});
}

class LoadedChatMessageState extends ChatState {
  final List<MessageModel> messages;
  const LoadedChatMessageState({required this.messages});
}

class InitializedChatState extends ChatState {
  final ChatModel chat;
  const InitializedChatState({required this.chat});
}

class LoadedMessageState extends ChatState {
    final List<MessageModel> messages;
  const LoadedMessageState({required this.messages});
}

class ErrorState extends ChatState {
  final String message;
  const ErrorState({required this.message});
}

class SuccessState extends ChatState{
  final String message;
  const SuccessState({required this.message});

}

class SendingMessageState extends ChatState {}

class MessageReceivedState extends ChatState {
  final MessageModel message;
  const MessageReceivedState({required this.message});
}
