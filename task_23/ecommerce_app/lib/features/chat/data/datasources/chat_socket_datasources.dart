import 'dart:async';

import 'package:logger/web.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../auth/data/datasources/auth_local_datasource.dart';
import '../../domain/entities/message.dart';
import '../models/message_model.dart';

abstract class ChatSocketDatasources {
  void connect(String token);
  void disconnect();
  Future<void> sendMessage(String chatId, String type, String content);
  Stream<Message> onMessageReceived();
  void markReceived(MessageModel message);
}

class ChatSocketDatasourcesImpl implements ChatSocketDatasources {
  IO.Socket? socket;
  final _messageController = StreamController<Message>.broadcast();
  final logger = Logger();
  final socketBaseUrl = 'https://g5-flutter-learning-path-be-tvum.onrender.com';

  final AuthLocalDatasource authLocalDatasource;

  ChatSocketDatasourcesImpl(
      {required this.socket, required this.authLocalDatasource});

  bool _isConnected = false;
  Completer<void>? _connectionCompleter;

  @override
  void connect(String token) {
    // check if socket already exists and connected
    if (socket != null && socket!.connected) {
      return;
    }

    _connectionCompleter = Completer<void>();

    socket = IO.io(socketBaseUrl, <String, dynamic>{
      'transports': ['websocket','polling'],
       'auth': {'token': token},
      'autoConnect': false
    });

    // register a connection listener
    socket!.onConnect((_) {
      _isConnected = true;
      logger.i(' Socket connected: ${socket!.id}');
      _connectionCompleter?.complete(); // complete connection future
    });

    socket!.onDisconnect((_) {
      _isConnected = false;
      logger.i('Socket Disconnected: ${socket!.id}');
    });

    // logging any Connection errors
    socket!.onError((err) {
      logger.e('Socket error: $err');
      if (!_connectionCompleter!.isCompleted) {
        _connectionCompleter?.completeError(err);
      }
    });

    //  Listen for incoming messages
    socket!.on('message:received', (data) {
      try {
        final message = MessageModel.fromJson(data);
        _messageController.add(message);
      } catch (e) {
        logger.e('failed to parse message $e');
      }
    });

    // start connection
    socket!.connect();
  }

  // wait for socket to connect
  Future<void> _waitForConnection() async {
    if (_isConnected) return;
    if (_connectionCompleter != null) {
      await _connectionCompleter!.future;
    }
  }

  @override
  void disconnect() {
    // disconnection and clearing socket
    socket?.disconnect();
    socket?.dispose();
    socket = null;
    _isConnected = false;
    _messageController.close();
    logger.i(' Socket Disconnected');
  }

  @override
  void markReceived(MessageModel message) {
    // mark a message as received
    if (socket == null || !_isConnected) {
      logger.i('No socket connection');
    }
    socket!.emit('message:received', message.toJson());
    logger.i('message marked as received');
  }

  @override
  Stream<Message> onMessageReceived() => _messageController.stream;

  @override
  Future<void> sendMessage(String chatId, String type, String content) async {
    final token = await authLocalDatasource.getToken();

    //  check we have a connected socket
    if (socket == null || !_isConnected) {
      connect(token);
      logger.i('Socket not connected yet, waiting for connection...');
      await _waitForConnection(); // wait for socket to be connected
    }

    final payLoad = {'chatId': chatId, 'content': content, 'type': type};
    print('sending,,,,,,,,,,,,,,,,,,,,,,,,,');
    socket!.emit('message:send', payLoad);
    logger.i('message sent $payLoad');
  }
}
