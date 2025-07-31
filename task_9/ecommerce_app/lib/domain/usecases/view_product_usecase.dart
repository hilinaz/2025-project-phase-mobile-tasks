import '../entities/product.dart';
import '../repositories/product_repository.dart';
import 'usecase.dart';

class ViewProductUsecase implements UseCase<Product?, String> {
  final ProductRepository repository;

  ViewProductUsecase(this.repository);

  @override
  Future<Product?> call(String productId) async {
    return await repository.getProductById(productId);
  }
}
