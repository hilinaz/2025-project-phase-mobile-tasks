import '../entities/product.dart';
import '../repositories/product_repository.dart';
import 'usecase.dart';

class UpdateProductUsecase implements UseCase<Product, Product> {
  final ProductRepository repository;

  UpdateProductUsecase(this.repository);

  @override
  Future<Product> call(Product product) async {
    return await repository.updateProduct(product);
  }
}
