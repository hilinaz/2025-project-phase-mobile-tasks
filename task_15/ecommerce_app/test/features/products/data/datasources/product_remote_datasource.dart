import 'dart:convert';

import 'package:ecommerce_app/core/error/exception.dart';
import 'package:ecommerce_app/features/products/data/datasources/product_remote_datasource_impl.dart';
import 'package:ecommerce_app/features/products/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

// Mock class for http.Client
class MockHttpClient extends Mock implements http.Client {}

void main() {
  late ProductRemoteDatasourceImpl datasource;
  late MockHttpClient mockHttpClient;

  const baseUrl = 'https://g5-flutter-learning-path-be.onrender.com/';

  setUp(() {
    mockHttpClient = MockHttpClient();
    datasource = ProductRemoteDatasourceImpl(client: mockHttpClient);
  });

  final tProductModel = ProductModel(
    id: '1',
    name: 'Test Product',
    description: 'Test Description',
    price: 10.0,
    imageUrl: 'http://image.url',
  );

  final tProductModelList = [tProductModel];
  final tJsonListString =
      json.encode(tProductModelList.map((p) => p.toJson()).toList());
  final tJsonString = json.encode(tProductModel.toJson());

  group('getAllProducts', () {
    test('should perform a GET request and return list of products on 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse(baseUrl)))
          .thenAnswer((_) async => http.Response(tJsonListString, 200));
      // act
      final result = await datasource.getAllProducts();
      // assert
      verify(mockHttpClient.get(Uri.parse(baseUrl)));
      expect(result, equals(tProductModelList));
    });

    test('should throw ServerException when response code is not 200',
        () async {
      when(mockHttpClient.get(Uri.parse(baseUrl)))
          .thenAnswer((_) async => http.Response('Error', 404));
      final call = datasource.getAllProducts;
      expect(() => call(), throwsA(isA<ServerException>()));
    });
  });

  group('getProductById', () {
    final id = '1';
    final uri = Uri.parse('$baseUrl/$id');

    test('should perform a GET request and return product on 200', () async {
      when(mockHttpClient.get(uri))
          .thenAnswer((_) async => http.Response(tJsonString, 200));
      final result = await datasource.getProductById(id);
      verify(mockHttpClient.get(uri));
      expect(result, equals(tProductModel));
    });

    test('should throw ServerException when response code is not 200',
        () async {
      when(mockHttpClient.get(uri))
          .thenAnswer((_) async => http.Response('Error', 404));
      final call = datasource.getProductById;
      expect(() => call(id), throwsA(isA<ServerException>()));
    });
  });

  group('createProduct', () {
    test('should perform POST request with correct data and succeed on 201',
        () async {
      when(mockHttpClient.post(
        Uri.parse(baseUrl),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('', 201));

      await datasource.createProduct(tProductModel);

      final expectedBody = json.encode(tProductModel.toJson());
      verify(mockHttpClient.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: expectedBody,
      ));
    });

    test('should throw ServerException when response code is not 201',
        () async {
      when(mockHttpClient.post(
        Uri.parse(baseUrl),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Error', 400));

      final call = datasource.createProduct;

      expect(() => call(tProductModel), throwsA(isA<ServerException>()));
    });
  });

  group('deleteProduct', () {
    final id = '1';
    final uri = Uri.parse('$baseUrl/$id');

    test('should perform DELETE request and succeed on 200', () async {
      when(mockHttpClient.delete(uri))
          .thenAnswer((_) async => http.Response('', 200));
      await datasource.deleteProduct(id);
      verify(mockHttpClient.delete(uri));
    });

    test('should perform DELETE request and succeed on 204', () async {
      when(mockHttpClient.delete(uri))
          .thenAnswer((_) async => http.Response('', 204));
      await datasource.deleteProduct(id);
      verify(mockHttpClient.delete(uri));
    });

    test('should throw ServerException when response code is not 200 or 204',
        () async {
      when(mockHttpClient.delete(uri))
          .thenAnswer((_) async => http.Response('Error', 404));
      final call = datasource.deleteProduct;
      expect(() => call(id), throwsA(isA<ServerException>()));
    });
  });

  group('updateProduct', () {
    test('should perform PUT request with correct data and succeed on 200',
        () async {
      when(mockHttpClient.put(
        Uri.parse('$baseUrl/${tProductModel.id}'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('', 200));

      await datasource.updateProduct(tProductModel);

      final expectedBody = json.encode(tProductModel.toJson());
      verify(mockHttpClient.put(
        Uri.parse('$baseUrl/${tProductModel.id}'),
        headers: {'Content-Type': 'application/json'},
        body: expectedBody,
      ));
    });

    test('should throw ServerException when response code is not 200',
        () async {
      when(mockHttpClient.put(
        Uri.parse('$baseUrl/${tProductModel.id}'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Error', 400));

      final call = datasource.updateProduct;

      expect(() => call(tProductModel), throwsA(isA<ServerException>()));
    });
  });
}
