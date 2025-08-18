import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:ecommerce_app/core/error/failures.dart';
import 'package:ecommerce_app/core/usecases/usecase.dart';
import 'package:ecommerce_app/features/products/data/models/product_model.dart';
import 'package:ecommerce_app/features/products/doamin/entities/product.dart';
import 'package:ecommerce_app/features/products/doamin/usecases/create_new_product.dart';
import 'package:ecommerce_app/features/products/doamin/usecases/delete_product.dart';
import 'package:ecommerce_app/features/products/doamin/usecases/update_product.dart';
import 'package:ecommerce_app/features/products/doamin/usecases/view_all_products.dart';
import 'package:ecommerce_app/features/products/doamin/usecases/view_specific_product.dart';
import 'package:ecommerce_app/features/products/presentation/bloc/product_bloc.dart';

import 'product_bloc_test.mocks.dart';

@GenerateMocks([
  CreateProductUsecase,
  UpdateProductUsecase,
  DeleteProductUsecase,
  ViewAllProductsUsecase,
  ViewProductUsecase,
])
void main() {
  late MockCreateProductUsecase mockCreateProductUsecase;
  late MockUpdateProductUsecase mockUpdateProductUsecase;
  late MockDeleteProductUsecase mockDeleteProductUsecase;
  late MockViewAllProductsUsecase mockViewAllProductsUsecase;
  late MockViewProductUsecase mockViewProductUsecase;
  late ProductBloc bloc;

  const testProduct = ProductModel(
    id: '1',
    name: 'Test Product',
    description: 'Test Description',
    imageUrl: 'http://test.com/image.png',
    price: 10.0,
  );

  setUp(() {
    mockViewProductUsecase = MockViewProductUsecase();
    mockViewAllProductsUsecase = MockViewAllProductsUsecase();
    mockDeleteProductUsecase = MockDeleteProductUsecase();
    mockUpdateProductUsecase = MockUpdateProductUsecase();
    mockCreateProductUsecase = MockCreateProductUsecase();

    bloc = ProductBloc(
      createProductUsecase: mockCreateProductUsecase,
      updateProductUsecase: mockUpdateProductUsecase,
      deleteProductUsecase: mockDeleteProductUsecase,
      getAllProductsUsecase: mockViewAllProductsUsecase,
      getProductUsecase: mockViewProductUsecase,
    );
  });

  test('initial state should be ProductInitial', () {
    expect(bloc.state, ProductInitial());
  });

  blocTest<ProductBloc, ProductState>(
    'emits [LoadingState, LoadedAllProductsState] when LoadAllProductEvent succeeds',
    build: () {
      when(mockViewAllProductsUsecase(any))
          .thenAnswer((_) async => Right([testProduct]));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadAllProductEvent()),
    expect: () => [
      LoadingState(),
      LoadedAllProductsState(products: [testProduct]),
    ],
    verify: (_) {
      verify(mockViewAllProductsUsecase(NoParams())).called(1);
    },
  );

  blocTest<ProductBloc, ProductState>(
    'emits [LoadingState, ErrorState] when LoadAllProductEvent fails',
    build: () {
      when(mockViewAllProductsUsecase(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadAllProductEvent()),
    expect: () => [
      LoadingState(),
      const ErrorState(message: 'Failed to load products'),
    ],
  );

  blocTest<ProductBloc, ProductState>(
    'emits [LoadingState, LoadedSingleProductState] when GetSingleProductEvent succeeds',
    build: () {
      when(mockViewProductUsecase(any))
          .thenAnswer((_) async => Right(testProduct));
      return bloc;
    },
    act: (bloc) => bloc.add(GetSingleProductEvent(productId: '1')),
    expect: () => [
      LoadingState(),
      LoadedSingleProductState(product: testProduct),
    ],
  );

  blocTest<ProductBloc, ProductState>(
    'emits [LoadingState, ErrorState] when GetSingleProductEvent fails',
    build: () {
      when(mockViewProductUsecase(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      return bloc;
    },
    act: (bloc) => bloc.add(GetSingleProductEvent(productId: '1')),
    expect: () => [
      LoadingState(),
      const ErrorState(message: 'Failed to load product'),
    ],
  );
}
