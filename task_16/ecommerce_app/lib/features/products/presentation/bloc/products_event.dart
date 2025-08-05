part of 'products_bloc.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductsEvent {}

class LoadProduct extends ProductsEvent {
  final String id;

  const LoadProduct({required this.id});

  @override
  List<Object> get props => [id];
}

class CreateProduct extends ProductsEvent {
  final Product product;

  const CreateProduct({required this.product});

  @override
  List<Object> get props => [product];
}

class UpdateProduct extends ProductsEvent {
  final Product product;

  const UpdateProduct({required this.product});

  @override
  List<Object> get props => [product];
}

class DeleteProduct extends ProductsEvent {
  final String id;

  const DeleteProduct({required this.id});

  @override
  List<Object> get props => [id];
} 