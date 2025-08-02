import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class InsertProductUseCase {
  final ProductRepository repository;

  InsertProductUseCase(this.repository);

  Future<void> execute(ProductEntity product) async {
    await repository.insertProduct(product);
  }
} 