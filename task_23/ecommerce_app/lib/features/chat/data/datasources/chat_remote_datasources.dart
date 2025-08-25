import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/error/exception.dart';
import '../../../auth/data/datasources/auth_local_datasource.dart';
import '../../../auth/data/model/user_model.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDatasources {
  Future<List<ChatModel>> getMyChats();
  Future<ChatModel> getChatById(String chatId);
  Future<void> deleteChat(String chatId);
  Future<List<MessageModel>> getChatMessages(String chatId);
  Future<ChatModel> initChat(String userId);
  Future<List<UserModel>> getAllUsers();
}

class ChatRemoteDatasourcesImpl implements ChatRemoteDatasources {
  final http.Client httpClient;
  final AuthLocalDatasource authLocalDatasource;
  final String baseUrl =
      'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v3';

  ChatRemoteDatasourcesImpl(this.httpClient, this.authLocalDatasource);

  @override
  Future<void> deleteChat(String chatId) async {
    final response = await httpClient.delete(
      Uri.parse('$baseUrl/chats/$chatId'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw ServerException();
    }
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    final token = await authLocalDatasource.getToken();
    final response = await httpClient.get(
      Uri.parse('$baseUrl/users'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<dynamic> jsonList = jsonResponse['data'];
      return jsonList.map((json) => UserModel.fromjson(json)).toList();
    } else {
      print(response.body);
      throw ServerException();
    }
  }

  @override
  Future<ChatModel> getChatById(String chatId) async {
    final response = await httpClient.get(
      Uri.parse('$baseUrl/chats/$chatId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return ChatModel.fromJson(jsonResponse['data']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MessageModel>> getChatMessages(String chatId) async {
    final token = await authLocalDatasource.getToken();
    final response = await httpClient.get(
      Uri.parse('$baseUrl/chats/$chatId/messages'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<dynamic> jsonList = jsonResponse['data'];
      return jsonList.map((json) => MessageModel.fromJson(json)).toList();
    } else {
      print(response.body);
      print('$baseUrl/chats/$chatId/messages');
      print(token);
      throw ServerException();
    }
  }

  @override
  Future<List<ChatModel>> getMyChats() async {
    final accessToken = await authLocalDatasource.getToken();

    final response = await httpClient.get(
      Uri.parse('$baseUrl/chats'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<dynamic> jsonList = jsonResponse['data'];
      return jsonList.map((json) => ChatModel.fromJson(json)).toList();
    } else {
      print(response.body);
      throw ServerException();
    }
  }

  @override
  Future<ChatModel> initChat(String userId) async {
    final token = await authLocalDatasource.getToken();
    final response = await httpClient.post(
      Uri.parse('$baseUrl/chats'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'userId': userId}),
    );
    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      final chatmodel = ChatModel.fromJson(jsonResponse);
      return chatmodel;
    } else {
      throw ServerException();
    }
  }
}
