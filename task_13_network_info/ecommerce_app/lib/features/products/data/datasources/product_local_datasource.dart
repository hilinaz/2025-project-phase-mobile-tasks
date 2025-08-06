
import '../models/product_model.dart';

abstract class ProductLocalDatasource {
  Future<ProductModel> getProduct();
  Future<List<ProductModel>> getProducts();
  Future<void> cacheProduct(ProductModel productModel);
  Future<void> cacheProducts(List<ProductModel> productmodels);
}
