import '../../../auth/data/model/user_model.dart';
import '../../domain/entities/message.dart';
import 'chat_model.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.chat,
    required super.content,
    required super.sender,
    required super.type,
    required super.timestamp,
    required super.status,
  });

  factory MessageModel.fromJson(Map<String, dynamic> data) {
    return MessageModel(
      id: data['_id'],
      chat: ChatModel.fromJson({'data': data['chat']}),
      sender: UserModel.fromjson(data['sender']),
      content: data['content'],
      type: data['type'],
      timestamp: DateTime.now(), 
      status: MessageStatus.sent,
    );
  }

  //Convert Entity to Model
  factory MessageModel.fromEntity(Message message) {
    return MessageModel(
      id: message.id,
      chat: ChatModel.fromEntity(message.chat),
      sender: UserModel.fromEntity(message.sender),
      content: message.content,
      type: message.type,
      timestamp: message.timestamp,
      status: message.status,
    );
  }

  //convert to JSON 
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'chat': (chat as ChatModel).toJson(),
      'sender': {
        '_id': sender.id,
        'name': sender.name,
        'email': sender.email,
      },
      'content': content,
      'type': type,
    };
  }
}
