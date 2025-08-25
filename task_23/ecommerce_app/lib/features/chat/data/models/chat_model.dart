import '../../../auth/data/model/user_model.dart';
import '../../domain/entities/chat.dart';

class ChatModel extends Chat {
  const ChatModel({
    required super.id,
    required super.user1,
    required super.user2,
  });

  factory ChatModel.fromJson(Map<String, dynamic> data) {
    return ChatModel(
      id: data['_id'] ?? '',
      user1: data['user1'] != null
          ? UserModel.fromjson(data['user1'])
          : const UserModel(id: '', name: '', email: ''),
      user2: data['user2'] != null
          ? UserModel.fromjson(data['user2'])
          : const UserModel(id: '', name: '', email: ''),
    );
  }

  // Convert Entity → Model
  factory ChatModel.fromEntity(Chat chat) {
    return ChatModel(
      id: chat.id.isNotEmpty ? chat.id : '',
      user1: UserModel.fromEntity(chat.user1),
      user2: UserModel.fromEntity(chat.user2),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id.isNotEmpty ? id : '',
      'user1': {
        '_id': user1.id.isNotEmpty ? user1.id : '',
        'name': user1.name.isNotEmpty ? user1.name : '',
        'email': user1.email.isNotEmpty ? user1.email : '',
      },
      'user2': {
        '_id': user2.id.isNotEmpty ? user2.id : '',
        'name': user2.name.isNotEmpty ? user2.name : '',
        'email': user2.email.isNotEmpty ? user2.email : '',
      },
    };
  }
}
