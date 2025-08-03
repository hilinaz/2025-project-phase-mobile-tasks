import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:ecommerce_app/core/error/exception.dart';
import 'package:ecommerce_app/core/error/failures.dart';
import 'package:ecommerce_app/core/platform/network_info.dart';
import 'package:ecommerce_app/features/products/data/datasources/product_local_datasource.dart';
import 'package:ecommerce_app/features/products/data/datasources/product_remote_datasource.dart';
import 'package:ecommerce_app/features/products/data/models/product_model.dart';
import 'package:ecommerce_app/features/products/data/repository/product_repository_impl.dart';
import 'package:ecommerce_app/features/products/doamin/entities/product.dart';

class MockNetworkInfo extends Mock implements NetworkInfo{}
class MockProductLocalDatasource extends Mock implements ProductLocalDatasource{}
class MockProductRemoteDatasoure extends Mock implements ProductRemoteDatasource{}


void main() {
  late ProductRepositoryImpl repository;
  late MockProductRemoteDatasoure mockRemoteDatasource;
  late MockProductLocalDatasource mockLocalDatasource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDatasource = MockProductRemoteDatasoure();
    mockLocalDatasource = MockProductLocalDatasource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ProductRepositoryImpl(
      remoteDatasource: mockRemoteDatasource,
      localDatasource: mockLocalDatasource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getProductById', () {
    const tId = '1';
    const tProductModel = ProductModel(
      id: '1',
      name: 'Test Product',
      description: 'Test Description',
      imageUrl: 'https://example.com/image.jpg',
      price: 99.99,
    );
    const Product tProduct = tProductModel;

    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDatasource.getProductById(tId))
          .thenAnswer((_) async => tProductModel);
      // act
      await repository.getProductById(tId);
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDatasource.getProductById(tId))
              .thenAnswer((_) async => tProductModel);
          // act
          final result = await repository.getProductById(tId);
          // assert
          verify(mockRemoteDatasource.getProductById(tId));
          expect(result, equals(Right(tProduct)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDatasource.getProductById(tId))
              .thenAnswer((_) async => tProductModel);
          // act
          await repository.getProductById(tId);
          // assert
          verify(mockRemoteDatasource.getProductById(tId));
          verify(mockLocalDatasource.cacheProduct(tProductModel));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDatasource.getProductById(tId))
              .thenThrow(ServerException());
          // act
          final result = await repository.getProductById(tId);
          // assert
          verify(mockRemoteDatasource.getProductById(tId));
          verifyZeroInteractions(mockLocalDatasource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocalDatasource.getProductById(tId))
              .thenAnswer((_) async => tProductModel);
          // act
          final result = await repository.getProductById(tId);
          // assert
          verifyZeroInteractions(mockRemoteDatasource);
          verify(mockLocalDatasource.getProductById(tId));
          expect(result, equals(Right(tProduct)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          // arrange
          when(mockLocalDatasource.getProductById(tId))
              .thenThrow(CacheException());
          // act
          final result = await repository.getProductById(tId);
          // assert
          verifyZeroInteractions(mockRemoteDatasource);
          verify(mockLocalDatasource.getProductById(tId));
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });

  group('getAllProducts', () {
    final tProductModels = [
      const ProductModel(
        id: '1',
        name: 'Test Product 1',
        description: 'Test Description 1',
        imageUrl: 'https://example.com/image1.jpg',
        price: 99.99,
      ),
      const ProductModel(
        id: '2',
        name: 'Test Product 2',
        description: 'Test Description 2',
        imageUrl: 'https://example.com/image2.jpg',
        price: 149.99,
      ),
    ];
    final List<Product> tProducts = tProductModels;

    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDatasource.getAllProducts())
          .thenAnswer((_) async => tProductModels);
      // act
      await repository.getAllProducts();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDatasource.getAllProducts())
              .thenAnswer((_) async => tProductModels);
          // act
          final result = await repository.getAllProducts();
          // assert
          verify(mockRemoteDatasource.getAllProducts());
          expect(result, equals(Right(tProducts)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDatasource.getAllProducts())
              .thenAnswer((_) async => tProductModels);
          // act
          await repository.getAllProducts();
          // assert
          verify(mockRemoteDatasource.getAllProducts());
          verify(mockLocalDatasource.cacheProduct(tProductModels as ProductModel));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDatasource.getAllProducts())
              .thenThrow(ServerException());
          // act
          final result = await repository.getAllProducts();
          // assert
          verify(mockRemoteDatasource.getAllProducts());
          verifyZeroInteractions(mockLocalDatasource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocalDatasource.getAllProducts())
              .thenAnswer((_) async => tProductModels);
          // act
          final result = await repository.getAllProducts();
          // assert
          verifyZeroInteractions(mockRemoteDatasource);
          verify(mockLocalDatasource.getAllProducts());
          expect(result, equals(Right(tProducts)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          // arrange
          when(mockLocalDatasource.getAllProducts())
              .thenThrow(CacheException());
          // act
          final result = await repository.getAllProducts();
          // assert
          verifyZeroInteractions(mockRemoteDatasource);
          verify(mockLocalDatasource.getAllProducts());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });

  group('createProduct', () {
    const tProduct = ProductModel(
      id: '1',
      name: 'Test Product',
      description: 'Test Description',
      imageUrl: 'https://example.com/image.jpg',
      price: 99.99,
    );

    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDatasource.createProduct(tProduct))
          .thenAnswer((_) async {});
      // act
      await repository.createProduct(tProduct);
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
        'should return void when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDatasource.createProduct(tProduct))
              .thenAnswer((_) async {});
          // act
          final result = await repository.createProduct(tProduct);
          // assert
          verify(mockRemoteDatasource.createProduct(tProduct));
          verify(mockLocalDatasource.cacheProduct(tProduct));
          expect(result, equals(const Right(null)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDatasource.createProduct(tProduct))
              .thenAnswer((_) async {});
          // act
          await repository.createProduct(tProduct);
          // assert
          verify(mockRemoteDatasource.createProduct(tProduct));
          verify(mockLocalDatasource.cacheProduct(tProduct));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDatasource.createProduct(tProduct))
              .thenThrow(ServerException());
          // act
          final result = await repository.createProduct(tProduct);
          // assert
          verify(mockRemoteDatasource.createProduct(tProduct));
          verifyZeroInteractions(mockLocalDatasource);
          expect(result, equals(Left(ServerFailure())));
        },
      );

      test(
        'should return cache failure when the call to local data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDatasource.createProduct(tProduct))
              .thenAnswer((_) async {});
          when(mockLocalDatasource.cacheProduct(tProduct))
              .thenThrow(CacheException());
          // act
          final result = await repository.createProduct(tProduct);
          // assert
          verify(mockRemoteDatasource.createProduct(tProduct));
          verify(mockLocalDatasource.cacheProduct(tProduct));
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return network failure when device is offline',
        () async {
          // act
          final result = await repository.createProduct(tProduct);
          // assert
          verifyZeroInteractions(mockRemoteDatasource);
          verifyZeroInteractions(mockLocalDatasource);
          expect(result, equals(Left(NetworkFailure())));
        },
      );
    });
  });

  group('updateProduct', () {
    const tProduct = ProductModel(
      id: '1',
      name: 'Updated Product',
      description: 'Updated Description',
      imageUrl: 'https://example.com/updated-image.jpg',
      price: 129.99,
    );

    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDatasource.updateProduct(tProduct))
          .thenAnswer((_) async {});
      // act
      await repository.updateProduct(tProduct);
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
        'should return void when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDatasource.updateProduct(tProduct))
              .thenAnswer((_) async {});
          // act
          final result = await repository.updateProduct(tProduct);
          // assert
          verify(mockRemoteDatasource.updateProduct(tProduct));
          verify(mockLocalDatasource.cacheProduct(tProduct));
          expect(result, equals(const Right(null)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDatasource.updateProduct(tProduct))
              .thenAnswer((_) async {});
          // act
          await repository.updateProduct(tProduct);
          // assert
          verify(mockRemoteDatasource.updateProduct(tProduct));
          verify(mockLocalDatasource.cacheProduct(tProduct));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDatasource.updateProduct(tProduct))
              .thenThrow(ServerException());
          // act
          final result = await repository.updateProduct(tProduct);
          // assert
          verify(mockRemoteDatasource.updateProduct(tProduct));
          verifyZeroInteractions(mockLocalDatasource);
          expect(result, equals(Left(ServerFailure())));
        },
      );

      test(
        'should return cache failure when the call to local data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDatasource.updateProduct(tProduct))
              .thenAnswer((_) async {});
          when(mockLocalDatasource.cacheProduct(tProduct))
              .thenThrow(CacheException());
          // act
          final result = await repository.updateProduct(tProduct);
          // assert
          verify(mockRemoteDatasource.updateProduct(tProduct));
          verify(mockLocalDatasource.cacheProduct(tProduct));
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return network failure when device is offline',
        () async {
          // act
          final result = await repository.updateProduct(tProduct);
          // assert
          verifyZeroInteractions(mockRemoteDatasource);
          verifyZeroInteractions(mockLocalDatasource);
          expect(result, equals(Left(NetworkFailure())));
        },
      );
    });
  });

  group('deleteProduct', () {
    const tId = '1';

    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDatasource.deleteProduct(tId)).thenAnswer((_) async {});
      // act
      await repository.deleteProduct(tId);
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
        'should return void when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDatasource.deleteProduct(tId))
              .thenAnswer((_) async {});
          // act
          final result = await repository.deleteProduct(tId);
          // assert
          verify(mockRemoteDatasource.deleteProduct(tId));
          verify(mockLocalDatasource.deleteProduct(tId));
          expect(result, equals(const Right(null)));
        },
      );

      test(
        'should delete from local cache when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDatasource.deleteProduct(tId))
              .thenAnswer((_) async {});
          // act
          await repository.deleteProduct(tId);
          // assert
          verify(mockRemoteDatasource.deleteProduct(tId));
          verify(mockLocalDatasource.deleteProduct(tId));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDatasource.deleteProduct(tId))
              .thenThrow(ServerException());
          // act
          final result = await repository.deleteProduct(tId);
          // assert
          verify(mockRemoteDatasource.deleteProduct(tId));
          verifyZeroInteractions(mockLocalDatasource);
          expect(result, equals(Left(ServerFailure())));
        },
      );

      test(
        'should return cache failure when the call to local data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDatasource.deleteProduct(tId))
              .thenAnswer((_) async {});
          when(mockLocalDatasource.deleteProduct(tId))
              .thenThrow(CacheException());
          // act
          final result = await repository.deleteProduct(tId);
          // assert
          verify(mockRemoteDatasource.deleteProduct(tId));
          verify(mockLocalDatasource.deleteProduct(tId));
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return network failure when device is offline',
        () async {
          // act
          final result = await repository.deleteProduct(tId);
          // assert
          verifyZeroInteractions(mockRemoteDatasource);
          verifyZeroInteractions(mockLocalDatasource);
          expect(result, equals(Left(NetworkFailure())));
        },
      );
    });
  });
}


