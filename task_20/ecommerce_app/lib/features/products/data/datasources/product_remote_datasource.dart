import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;

import '../../../../core/error/exception.dart';
import '../../doamin/entities/product.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDatasource {
  Future<List<ProductModel>> getAllProducts();
  Future<ProductModel> getProductById(String id);
  Future<void> createProduct(Product product, File? imageFile);
  Future<void> deleteProduct(String id);
  Future<void> updateProduct(Product product);
}

class ProductRemoteDatasourceImp implements ProductRemoteDatasource {
  final http.Client httpClient;
  ProductRemoteDatasourceImp(this.httpClient);
  @override
Future<void> createProduct(Product product, File? imageFile) async {
    final uri = Uri.parse(
        'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v1/products/');

    final request = http.MultipartRequest('POST', uri);

   
    request.fields['name'] = product.name;
    request.fields['description'] = product.description;
    request.fields['price'] = product.price.toString();

    if (imageFile != null) {
    
      final mimeType = lookupMimeType(imageFile.path);
      final mediaType = mimeType != null ? MediaType.parse(mimeType) : null;

      request.files.add(
        
        http.MultipartFile(
          'image',
          imageFile.readAsBytes().asStream(),
          imageFile.lengthSync(),
          filename: path.basename(imageFile.path),
          contentType: mediaType,
        ),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 201) {
      print('Failed to create product. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw ServerException();
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    final response = await httpClient.delete(
      Uri.parse(
          'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v1/products/$id'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw ServerException();
    }
  }

  @override
  @override
  Future<List<ProductModel>> getAllProducts() async {
    final response = await httpClient.get(
      Uri.parse(
          'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v1/products/'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<dynamic> jsonList = jsonResponse['data'];
      return jsonList.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    final response = await httpClient.get(
      Uri.parse(
          'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v1/products/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final productJson = jsonResponse['data']; // extract the nested product
      return ProductModel.fromJson(productJson);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> updateProduct(Product product) async {
    final response = await httpClient.put(
      Uri.parse(
          'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v1/products/${product.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw ServerException();
    }
  }
}
