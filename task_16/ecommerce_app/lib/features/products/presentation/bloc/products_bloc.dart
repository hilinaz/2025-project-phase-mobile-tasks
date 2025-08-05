import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/error_handler.dart';
import '../../doamin/entities/product.dart';
import '../../doamin/usecases/create_new_product.dart';
import '../../doamin/usecases/delete_product.dart';
import '../../doamin/usecases/update_product.dart';
import '../../doamin/usecases/view_all_products.dart';
import '../../doamin/usecases/view_specific_product.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ViewAllProductsUsecase viewAllProducts;
  final ViewProductUsecase viewProduct;
  final CreateProductUsecase createProduct;
  final UpdateProductUsecase updateProduct;
  final DeleteProductUsecase deleteProduct;

  ProductsBloc({
    required this.viewAllProducts,
    required this.viewProduct,
    required this.createProduct,
    required this.updateProduct,
    required this.deleteProduct,
  }) : super(ProductsInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadProduct>(_onLoadProduct);
    on<CreateProduct>(_onCreateProduct);
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
  }

  Future<void> _onLoadProducts(LoadProducts event, Emitter<ProductsState> emit) async {
    emit(ProductsLoading());
    
    final result = await viewAllProducts(NoParams());
    
    if (result.isSuccess) {
      emit(ProductsLoaded(products: result.success!));
    } else {
      emit(ProductsError(message: result.errorMessage));
    }
  }

  Future<void> _onLoadProduct(LoadProduct event, Emitter<ProductsState> emit) async {
    emit(ProductLoading());
    
    final result = await viewProduct(Params(id: event.id));
    
    if (result.isSuccess) {
      emit(ProductLoaded(product: result.success!));
    } else {
      emit(ProductError(message: result.errorMessage));
    }
  }

  Future<void> _onCreateProduct(CreateProduct event, Emitter<ProductsState> emit) async {
    emit(ProductOperationLoading());
    
    final result = await createProduct(Params(product: event.product));
    
    if (result.isSuccess) {
      emit(ProductOperationSuccess(message: 'Product created successfully'));
      // Reload products list
      add(LoadProducts());
    } else {
      emit(ProductOperationError(message: result.errorMessage));
    }
  }

  Future<void> _onUpdateProduct(UpdateProduct event, Emitter<ProductsState> emit) async {
    emit(ProductOperationLoading());
    
    final result = await updateProduct(Params(product: event.product));
    
    if (result.isSuccess) {
      emit(ProductOperationSuccess(message: 'Product updated successfully'));
      // Reload products list
      add(LoadProducts());
    } else {
      emit(ProductOperationError(message: result.errorMessage));
    }
  }

  Future<void> _onDeleteProduct(DeleteProduct event, Emitter<ProductsState> emit) async {
    emit(ProductOperationLoading());
    
    final result = await deleteProduct(Params(id: event.id));
    
    if (result.isSuccess) {
      emit(ProductOperationSuccess(message: 'Product deleted successfully'));
      // Reload products list
      add(LoadProducts());
    } else {
      emit(ProductOperationError(message: result.errorMessage));
    }
  }
} 