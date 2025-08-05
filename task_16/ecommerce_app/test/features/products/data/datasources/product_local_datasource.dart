import 'dart:convert';

import 'package:ecommerce_app/core/error/exception.dart';
import 'package:ecommerce_app/features/products/data/datasources/product_local_datasource.dart';
import 'package:ecommerce_app/features/products/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late ProductLocalDatasourceImpl datasource;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    datasource = ProductLocalDatasourceImpl(sharedPreferences: mockPrefs);
  });

  const tProductModel = ProductModel(
      id: '1',
      name: 'Test',
      description: 'desc',
      price: 12.0,
      imageUrl: 'image/..');
  final tProductModelList = [tProductModel];
  final tJsonString =
      json.encode(tProductModelList.map((e) => e.toJson()).toList());

  group('getAllProducts', () {
    test('should return product list from SharedPreferences when there is data',
        () async {
      // arrange
      when(mockPrefs.getString(CACHED_PRODUCTS)).thenReturn(tJsonString);

      // act
      final result = await datasource.getAllProducts();

      // assert
      verify(mockPrefs.getString(CACHED_PRODUCTS));
      expect(result, equals(tProductModelList));
    });

    test('should throw CacheException when there is no cached data', () async {
      when(mockPrefs.getString(CACHED_PRODUCTS)).thenReturn(null);

      final call = datasource.getAllProducts;

      expect(() => call(), throwsA(isA<CacheException>()));
    });
  });

  group('cacheProduct', () {
    test('should call SharedPreferences to cache the data', () async {
      when(mockPrefs.getString(CACHED_PRODUCTS)).thenReturn(null);

      await datasource.cacheProduct(tProductModel);

      final expectedJsonString = json.encode([tProductModel.toJson()]);

      verify(mockPrefs.setString(CACHED_PRODUCTS, expectedJsonString));
    });
  });

  group('getProductById', () {
    test('should return product if found in cache', () async {
      when(mockPrefs.getString(CACHED_PRODUCTS)).thenReturn(tJsonString);

      final result = await datasource.getProductById('1');

      expect(result, tProductModel);
    });

    test('should throw CacheException if product not found', () async {
      when(mockPrefs.getString(CACHED_PRODUCTS)).thenReturn(tJsonString);

      final call = datasource.getProductById;

      expect(() => call('unknown'), throwsA(isA<CacheException>()));
    });
  });

  group('deleteProduct', () {
    test('should remove product and update cache', () async {
      when(mockPrefs.getString(CACHED_PRODUCTS)).thenReturn(tJsonString);

      await datasource.deleteProduct('1');

      verify(mockPrefs.setString(CACHED_PRODUCTS, json.encode([])));
    });
  });
}
