import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../auth/data/model/user_model.dart';
import '../../data/models/chat_model.dart';
import '../../data/models/message_model.dart';
import '../../domain/entities/message.dart';
import '../../domain/usecases/delete_chat.dart';
import '../../domain/usecases/get_all_user.dart';
import '../../domain/usecases/get_chat_by_id.dart';
import '../../domain/usecases/get_chat_messages.dart';
import '../../domain/usecases/get_my_chats.dart';
import '../../domain/usecases/init_chat.dart';
import '../../domain/usecases/mark_as_recieved.dart';
import '../../domain/usecases/on_message_recieved.dart';
import '../../domain/usecases/send_message.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetMyChats getMyChats;
  final GetChatById getChatById;
  final DeleteChat deleteChat;
  final SendMessage sendMessage;
  final OnMessageReceived onMessageReceived;
  final InitChat initChat;
  final MarkAsRecieved markAsRecieved;
  final GetAllUser getAllUser;
  final GetChatMessages getChatMessages;
  ChatBloc(
      {required this.getMyChats,
      required this.getChatById,
      required this.deleteChat,
      required this.sendMessage,
      required this.onMessageReceived,
      required this.initChat,
      required this.markAsRecieved,
      required this.getAllUser,
      required this.getChatMessages})
      : super(ChatInitial()) {
    on<LoadAllChatsEvent>(_loadAllChats);
    on<LoadChatMessageEvent>(_loadChatMessage);
    on<InitiateNewChatEvent>(_initNewChat);
    on<GetAllUsersEvent>(_getAllUsers);
    on<MessageReceivedEvent>(_messageReceived);
    on<SendMessageEvent>(_sendMessage);
    on<DeleteChatEvent>(_deleteChat);
    on<MarkMessageReceivedEvent>(_markAsRecieved);
    onMessageReceived().listen((message) {
      add(MessageReceivedEvent(message: message));
    }, onError: (_) {
      log('Failed to recieve event');
    });
  }

  Future<void> _loadAllChats(
      LoadAllChatsEvent event, Emitter<ChatState> emit) async {
    emit(LoadingState());

    final result = await getMyChats(const NoParams());

    result.fold(
      (failure) => emit(const ErrorState(message: 'Failed to load chats')),
      (chats) {
        final chatModels = chats
            .map((c) => ChatModel(id: c.id, user1: c.user1, user2: c.user2))
            .toList();
        emit(LoadedChatsState(chats: chatModels));
      },
    );
  }

  Future<void> _loadChatMessage(
      LoadChatMessageEvent event, Emitter<ChatState> emit) async {
    emit(LoadingState());
    final result =
        await getChatMessages(GetChatMessageParams(chatId: event.chatId));
    result.fold(
        (failure) => emit(const ErrorState(message: 'Failed to load messages')),
        (messages) {
      final messageM = messages
          .map((message) => MessageModel(
              id: message.id,
              chat: message.chat,
              content: message.content,
              sender: message.sender,
              type: message.type,
              timestamp: DateTime.now(),
              status: MessageStatus.delivered))
          .toList();
      emit(LoadedChatMessageState(messages: messageM));
    });
  }

  Future<void> _initNewChat(
      InitiateNewChatEvent event, Emitter<ChatState> emit) async {
    final result = await initChat(InitChatParams(userId: event.userId));
    result.fold(
        (failure) =>
            emit(const ErrorState(message: 'Failed to initialize chat')),
        (chat) {
      emit(InitializedChatState(chat: ChatModel.fromEntity(chat)));
    });
  }

  Future<void> _messageReceived(
      MessageReceivedEvent event, Emitter<ChatState> emit) async {
    emit(MessageReceivedState(message: MessageModel.fromEntity(event.message)));
  }

  Future<void> _sendMessage(
      SendMessageEvent event, Emitter<ChatState> emit) async {
    emit(LoadingState());
    final result = await sendMessage(SendMessageParams(
        ChatId: event.ChatId, Content: event.Content, type: event.type));
    result.fold(
        (failure) => emit(const ErrorState(message: 'Failed to send message')),
        (_) {
      emit(const SuccessState(message: 'Message sent'));
    });
  }

  Future<void> _deleteChat(
      DeleteChatEvent event, Emitter<ChatState> emit) async {
    emit(LoadingState());
    final result = await deleteChat(DeleteChatParams(chatId: event.chatId));
    result.fold(
        (failure) => emit(const ErrorState(message: 'Failed to delete chats')),
        (_) {
      emit(const SuccessState(message: 'Chat deleted successfully'));
      add(LoadAllChatsEvent());
    });
  }

  Future<void> _markAsRecieved(
      MarkMessageReceivedEvent event, Emitter<ChatState> emit) async {
    final result =
        await markAsRecieved(MarkAsRecievedParams(message: event.message));
    result.fold(
        (failure) => emit(const ErrorState(message: 'Failed to delete chats')),
        (_) {
      emit(const SuccessState(message: 'Message Recieved'));
    });
  }

  Future<void> _getAllUsers(
      GetAllUsersEvent event, Emitter<ChatState> emit) async {
    emit(LoadingState());
    final result = await getAllUser(NoParams());
    result.fold(
        (failure) => emit(const ErrorState(message: 'Failed to start chats')),
        (userList) {
      final userModels = userList
          .map((user) =>
              UserModel(id: user.id, name: user.name, email: user.email))
          .toList();
      emit(LoadedAllUsersState(users: userModels));
    });
  }
}
