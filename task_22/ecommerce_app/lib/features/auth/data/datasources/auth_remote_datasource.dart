import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/error/exception.dart';
import '../models/auth_model.dart';

abstract class AuthRemoteDatasource {
  Future<AuthModel> signUp(String name, String email, String password);
  Future<AuthModel> login(String email, String password);
  Future<void> logout();
}

class AuthRemoteDatasourceImp implements AuthRemoteDatasource {
  final http.Client httpClient;
  AuthRemoteDatasourceImp(this.httpClient);
  @override
  Future<AuthModel> login(String email, String password) async {
    final response = await httpClient.post(
      Uri.parse(
          'https://g5-flutter-learning-path-be.onrender.com/api/v2/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return AuthModel.fromJson(jsonResponse);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> logout() async{
    return await  Future.value();
  }

  @override
  Future<AuthModel> signUp(String name, String email, String password) async {
    final response = await httpClient.post(
      Uri.parse(
          'https://g5-flutter-learning-path-be.onrender.com/api/v2/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      return AuthModel.fromJson(jsonResponse);
    } else {
      throw ServerException();
    }
  }
}
