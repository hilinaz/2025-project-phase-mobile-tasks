

import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel(
      {required super.id, required super.name, required super.email});

  factory UserModel.fromjson(Map<String, dynamic> json) {
    return UserModel(
        id: json['_id'] , name: json['name'], email: json['email']);
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}
