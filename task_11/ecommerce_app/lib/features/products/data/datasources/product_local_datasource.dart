import '../models/product_model.dart';

abstract class ProductLocalDatasource {
  Future<ProductModel> getProduct();
  Future<void> cacheProduct(ProductModel productModel);
}
