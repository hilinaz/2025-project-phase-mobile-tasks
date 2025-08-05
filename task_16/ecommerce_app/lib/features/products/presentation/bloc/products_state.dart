part of 'products_bloc.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();
  
  @override
  List<Object> get props => [];
}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<Product> products;

  const ProductsLoaded({required this.products});

  @override
  List<Object> get props => [products];
}

class ProductsError extends ProductsState {
  final String message;

  const ProductsError({required this.message});

  @override
  List<Object> get props => [message];
}

class ProductLoading extends ProductsState {}

class ProductLoaded extends ProductsState {
  final Product product;

  const ProductLoaded({required this.product});

  @override
  List<Object> get props => [product];
}

class ProductError extends ProductsState {
  final String message;

  const ProductError({required this.message});

  @override
  List<Object> get props => [message];
}

class ProductOperationLoading extends ProductsState {}

class ProductOperationSuccess extends ProductsState {
  final String message;

  const ProductOperationSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class ProductOperationError extends ProductsState {
  final String message;

  const ProductOperationError({required this.message});

  @override
  List<Object> get props => [message];
} 