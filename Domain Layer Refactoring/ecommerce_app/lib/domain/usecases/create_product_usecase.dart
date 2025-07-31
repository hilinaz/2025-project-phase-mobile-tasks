import '../entities/product.dart';
import '../repositories/product_repository.dart';
import 'usecase.dart';

class CreateProductUsecase implements UseCase<Product, Product> {
  final ProductRepository repository;

  CreateProductUsecase(this.repository);

  @override
  Future<Product> call(Product product) async {
    return await repository.createProduct(product);
  }
}
