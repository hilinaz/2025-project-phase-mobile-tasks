part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class LoadingState extends ProductState {}

class LoadedAllProductsState extends ProductState {
  final List<ProductModel> products;
  const LoadedAllProductsState({required this.products});
  @override
  List<Object> get props => [products];
}

class LoadedSingleProductState extends ProductState {
  final Product product;
  const LoadedSingleProductState({required this.product});
  @override
  List<Object> get props => [product];
}

class ErrorState extends ProductState {
  final String message;
  const ErrorState({required this.message});

  @override
  List<Object> get props => [message];

}

class SuccessState extends ProductState {
  final String message;
  const SuccessState({required this.message});

  @override
  List<Object> get props => [message];
}


