
import 'package:equatable/equatable.dart';

import '../../../auth/domain/entities/user.dart';
import 'chat.dart';

enum MessageStatus { sent, delivered, received }

class Message extends Equatable {
  final String id;
  final Chat chat;
  final User sender;
  final String content;
  final String type;
  final DateTime timestamp;
  final MessageStatus status;
  const Message(
      {required this.id,
      required this.chat,
      required this.content,
      required this.sender,
      required this.type,
      required this.timestamp,
      required this.status});

  @override
  List<Object?> get props =>
      [id, chat, content, sender, type, timestamp, status];
}
