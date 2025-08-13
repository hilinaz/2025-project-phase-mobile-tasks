import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../data/models/product_model.dart';
import '../../doamin/entities/product.dart';

import '../../doamin/usecases/create_new_product.dart' as create_product;
import '../../doamin/usecases/delete_product.dart' as delete_product;
import '../../doamin/usecases/update_product.dart' as update_product;
import '../../doamin/usecases/view_all_products.dart' as view_all;
import '../../doamin/usecases/view_specific_product.dart' as view_specific;

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final view_all.ViewAllProductsUsecase getAllProductsUsecase;
  final view_specific.ViewProductUsecase getProductUsecase;
  final create_product.CreateProductUsecase createProductUsecase;
  final update_product.UpdateProductUsecase updateProductUsecase;
  final delete_product.DeleteProductUsecase deleteProductUsecase;

  ProductBloc({
    required this.createProductUsecase,
    required this.updateProductUsecase,
    required this.deleteProductUsecase,
    required this.getAllProductsUsecase,
    required this.getProductUsecase,
  }) : super(ProductInitial()) {
    on<LoadAllProductEvent>(_loadAllProducts);
    on<GetSingleProductEvent>(_getSingleProduct);
    on<CreateProductEvent>(_createProduct);
    on<UpdateProductEvent>(_updateProduct);
    on<DeleteProductEvent>(_deleteProduct);
  }

  Future<void> _loadAllProducts(
    LoadAllProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(LoadingState());

    final result = await getAllProductsUsecase(const NoParams());

    result.fold(
      (failure) => emit(const ErrorState(message: 'Failed to load products')),
      (products) => emit(
        LoadedAllProductsState(
          products: products
              .map((p) => ProductModel(
                    id: p.id,
                    name: p.name,
                    description: p.description,
                    imageUrl: p.imageUrl,
                    price: p.price,
                  ))
              .toList(),
        ),
      ),
    );
  }

  Future<void> _getSingleProduct(
    GetSingleProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(LoadingState());

    final result = await getProductUsecase(
      view_specific.Params(id: event.productId),
    );

    result.fold(
      (failure) => emit(const ErrorState(message: 'Failed to load product')),
      (product) => emit(
        LoadedSingleProductState(
          product: ProductModel(
            id: product.id,
            name: product.name,
            description: product.description,
            imageUrl: product.imageUrl,
            price: product.price,
          ),
        ),
      ),
    );
  }

  Future<void> _createProduct(
    CreateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(LoadingState());

    final result = await createProductUsecase(
      create_product.Params(product: event.product),
    );

    result.fold(
      (failure) => emit(ErrorState(message: failure.message)),
      (_) {
       
        add(LoadAllProductEvent()); 
      },
    );
  }

  Future<void> _updateProduct(
    UpdateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(LoadingState());

    final result = await updateProductUsecase(
      update_product.Params(product: event.product),
    );

    result.fold(
      (failure) => emit(ErrorState(message: failure.message)),
      (_) {
      
        add(LoadAllProductEvent());
      },
    );
  }

  Future<void> _deleteProduct(
    DeleteProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(LoadingState());

    final result = await deleteProductUsecase(
      delete_product.Params(id: event.productId),
    );

    result.fold(
      (failure) => emit(ErrorState(message: failure.message)),
      (_) {
    
        add(LoadAllProductEvent()); 
      },
    );
  }
}
