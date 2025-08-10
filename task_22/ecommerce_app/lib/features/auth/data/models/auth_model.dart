import '../../domain/entities/user.dart';

class AuthModel extends User {
  const AuthModel(
      {required super.id,
      required super.name,
      required super.email,
      required super.token});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        token: json['token']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'token': token};
  }
}
