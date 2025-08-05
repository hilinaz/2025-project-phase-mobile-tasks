import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../error/exception.dart';

class HttpService {
  final http.Client client;

  HttpService({required this.client});

  /// Generic GET request
  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await client.get(
        Uri.parse('${AppConstants.baseUrl}$endpoint'),
        headers: AppConstants.defaultHeaders,
      );

      return _handleResponse(response);
    } catch (e) {
      throw ServerException();
    }
  }

  /// Generic POST request
  Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await client.post(
        Uri.parse('${AppConstants.baseUrl}$endpoint'),
        headers: AppConstants.defaultHeaders,
        body: json.encode(body),
      );

      return _handleResponse(response);
    } catch (e) {
      throw ServerException();
    }
  }

  /// Generic PUT request
  Future<Map<String, dynamic>> put(
      String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await client.put(
        Uri.parse('${AppConstants.baseUrl}$endpoint'),
        headers: AppConstants.defaultHeaders,
        body: json.encode(body),
      );

      return _handleResponse(response);
    } catch (e) {
      throw ServerException();
    }
  }

  /// Generic DELETE request
  Future<void> delete(String endpoint) async {
    try {
      final response = await client.delete(
        Uri.parse('${AppConstants.baseUrl}$endpoint'),
        headers: AppConstants.defaultHeaders,
      );

      _handleResponse(response);
    } catch (e) {
      throw ServerException();
    }
  }

  /// Handle HTTP response and return parsed JSON
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {};
      }
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw ServerException();
    }
  }

  /// Handle list responses (for GET requests that return arrays)
  List<Map<String, dynamic>> _handleListResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.cast<Map<String, dynamic>>();
    } else {
      throw ServerException();
    }
  }

  /// Generic GET request that returns a list
  Future<List<Map<String, dynamic>>> getList(String endpoint) async {
    try {
      final response = await client.get(
        Uri.parse('${AppConstants.baseUrl}$endpoint'),
        headers: AppConstants.defaultHeaders,
      );

      return _handleListResponse(response);
    } catch (e) {
      throw ServerException();
    }
  }
}
