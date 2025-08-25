import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

abstract class ChatLocalDatasources {
  Future<void> cacheChats(List<ChatModel> chats);
  Future<List<ChatModel>> getCachedChats();
  Future<void> cacheMessages(String chatId, List<MessageModel> messages);
  Future<List<MessageModel>> getCachedMessages(String chatId);
  Future<void> clearCachedChats();
  Future<void> clearCachedMessages(String chatId);
}

class ChatLocalDatasourcesImpl implements ChatLocalDatasources {
  final SharedPreferences sharedPreferences;
  static const String chatsKey = 'CACHED_CHATS';

  ChatLocalDatasourcesImpl(this.sharedPreferences);

  @override
  Future<void> cacheChats(List<ChatModel> chats) async {
    final chatJsonList = chats.map((chat) => chat.toJson()).toList();
    await sharedPreferences.setString(chatsKey, jsonEncode(chatJsonList));
  }

  @override
  Future<List<ChatModel>> getCachedChats() async {
    final jsonString = sharedPreferences.getString(chatsKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => ChatModel.fromJson(json)).toList();
    }
    return [];
  }

  @override
  Future<void> cacheMessages(String chatId, List<MessageModel> messages) async {
    final messageJsonList = messages.map((msg) => msg.toJson()).toList();
    await sharedPreferences.setString(
        'MESSAGES_$chatId', jsonEncode(messageJsonList));
  }

  @override
  Future<List<MessageModel>> getCachedMessages(String chatId) async {
    final jsonString = sharedPreferences.getString('MESSAGES_$chatId');
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => MessageModel.fromJson(json)).toList();
    }
    return [];
  }

  @override
  Future<void> clearCachedChats() async {
    await sharedPreferences.remove(chatsKey);
  }

  @override
  Future<void> clearCachedMessages(String chatId) async {
    await sharedPreferences.remove('MESSAGES_$chatId');
  }
}
