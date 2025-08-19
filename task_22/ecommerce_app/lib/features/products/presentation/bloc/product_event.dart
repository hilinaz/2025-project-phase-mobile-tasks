part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class LoadAllProductEvent extends ProductEvent {}

class GetSingleProductEvent extends ProductEvent {
  final String productId;
  const GetSingleProductEvent({required this.productId});
}

class UpdateProductEvent extends ProductEvent {
  final Product product;

  const UpdateProductEvent({
    required this.product,
  });
}

class DeleteProductEvent extends ProductEvent {
  final String productId;
  const DeleteProductEvent({required this.productId});
}

class CreateProductEvent extends ProductEvent {
  final Product product;
final File? imageFile;

  const CreateProductEvent({
    required this.product,
    required this.imageFile
  });
}
