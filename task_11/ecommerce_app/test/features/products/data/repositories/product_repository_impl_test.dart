import 'package:ecommerce_app/core/platform/network_info.dart';
import 'package:ecommerce_app/features/products/data/datasources/product_local_datasource.dart';
import 'package:ecommerce_app/features/products/data/datasources/product_remote_datasource.dart';
import 'package:ecommerce_app/features/products/data/repository/product_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockProductLocalDataSource extends Mock
    implements ProductLocalDatasource {}

class MockProuctRemoteDataSource extends Mock
    implements ProductRemoteDatasource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late ProductRepositoryImpl repositoryImpl;
  late MockProductLocalDataSource mockProductLocalDataSource;
  late MockProuctRemoteDataSource mockProuctRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;
  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockProuctRemoteDataSource = MockProuctRemoteDataSource();
    mockProductLocalDataSource = MockProductLocalDataSource();
    repositoryImpl = ProductRepositoryImpl(
        localDatasource: mockProductLocalDataSource,
        remoteDatasource: mockProuctRemoteDataSource,
        networkInfo: mockNetworkInfo);
  });
}
