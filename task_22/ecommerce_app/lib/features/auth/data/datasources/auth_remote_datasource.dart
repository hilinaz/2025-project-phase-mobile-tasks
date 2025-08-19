import 'dart:convert';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/exception.dart';
import '../model/user_model.dart';
import 'auth_local_datasource.dart';

abstract class AuthRemoteDatasource {
  Future<UserModel> logIn(String email, String password);
  Future<UserModel> signUp(String name, String email, String password);
  Future<void> logOut();
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final http.Client httpClient;
  final AuthLocalDatasource localDatasource;
  final String baseUrl =
      "https://g5-flutter-learning-path-be-tvum.onrender.com/api/v2";

  AuthRemoteDatasourceImpl(this.httpClient, this.localDatasource);

  @override
  Future<UserModel> logIn(String email, String password) async {
    final response = await httpClient.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonRes = jsonDecode(response.body);
      final token = jsonRes['data']['access_token'];

      Map<String, dynamic> decodedToken = {};
      try {
        decodedToken = JwtDecoder.decode(token);
      } catch (_) {}
       print(
          '//////////////////////////////////////////////////////////////////////////////////');
      final user = UserModel(
        id: decodedToken['sub']?.toString() ?? '',
        name: decodedToken['name'] ?? '',
        email: decodedToken['email'] ?? email,
      );
     

      await localDatasource.cacheToken(token);
      await localDatasource.cacheUser(user);

      return user;
    } else {
      print(response.body);
      throw ServerException();
    }
  }

  @override
  Future<UserModel> signUp(String name, String email, String password) async {
    final response = await httpClient.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      final data = jsonResponse['data'];

      final user = UserModel.fromjson(data);

      // Cache the user
      await localDatasource.cacheUser(user);

      return user;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> logOut() async {
    await localDatasource.clearToken();
    await localDatasource.clearUser();
  }
}
