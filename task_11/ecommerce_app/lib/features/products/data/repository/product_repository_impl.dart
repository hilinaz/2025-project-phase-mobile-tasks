import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/platform/network_info.dart';
import '../../doamin/entities/product.dart';
import '../../doamin/repositories/product_repository.dart';
import '../datasources/product_local_datasource.dart';
import '../datasources/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDatasource localDatasource;
  final ProductRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;
  ProductRepositoryImpl(
      {required this.localDatasource,
      required this.remoteDatasource,
      required this.networkInfo});

  @override
  Future<Either<Failure, void>> createProduct(Product product) {
    // TODO: implement createProduct
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) {
    // TODO: implement deleteProduct
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Product>>> getAllProducts() {
    // TODO: implement getAllProducts
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Product>> getProductById(String id) {
    // TODO: implement getProductById
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> updateProduct(Product product) {
    // TODO: implement updateProduct
    throw UnimplementedError();
  }
}
