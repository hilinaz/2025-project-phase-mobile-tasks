import 'package:dartz/dartz.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failures.dart';

import '../../../../core/platform/network_info.dart';
import '../../doamin/entities/product.dart';
import '../../doamin/repositories/product_repository.dart';
import '../datasources/product_local_datasource.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource remoteDatasource;
  final ProductLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Product>> getProductById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProduct = await remoteDatasource.getProductById(id);
        await localDatasource.cacheProduct(remoteProduct);
        return Right(remoteProduct);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localProduct = await localDatasource.getProductById(id);
        return Right(localProduct);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getAllProducts() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProducts = await remoteDatasource.getAllProducts();
        // Caching skipped for list (unless you implement batch cache)
        return Right(remoteProducts);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localProducts = await localDatasource.getAllProducts();
        return Right(localProducts);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, void>> createProduct(Product product) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDatasource.createProduct(product);
        await localDatasource.cacheProduct(product as ProductModel);
        return const Right(null);
      } on ServerException {
        return Left(ServerFailure());
      } on CacheException {
        return Left(CacheFailure());
      }
    } else {
      return Left(NetworkFailure()); 
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct(Product product) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDatasource.updateProduct(product);
        await localDatasource.cacheProduct(product as ProductModel);
        return const Right(null);
      } on ServerException {
        return Left(ServerFailure());
      } on CacheException {
        return Left(CacheFailure());
      }
    } else {
      return Left(NetworkFailure()); 
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDatasource.deleteProduct(id);
        await localDatasource.deleteProduct(id);
        return const Right(null);
      } on ServerException {
        return Left(ServerFailure());
      } on CacheException {
        return Left(CacheFailure());
      }
    } else {
      return Left(NetworkFailure()); 
    }
  }
}
