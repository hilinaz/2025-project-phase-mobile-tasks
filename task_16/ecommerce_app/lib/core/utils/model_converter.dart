import '../../features/products/doamin/entities/product.dart';
import '../../features/products/data/models/product_model.dart';

/// Utility class for converting between different model types
class ModelConverter {
  /// Convert Product entity to ProductModel
  static ProductModel productToModel(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
    );
  }

  /// Convert ProductModel to Product entity
  static Product modelToProduct(ProductModel model) {
    return Product(
      id: model.id,
      name: model.name,
      description: model.description,
      price: model.price,
      imageUrl: model.imageUrl,
    );
  }

  /// Convert list of Product entities to ProductModel list
  static List<ProductModel> productsToModels(List<Product> products) {
    return products.map((product) => productToModel(product)).toList();
  }

  /// Convert list of ProductModel to Product entities list
  static List<Product> modelsToProducts(List<ProductModel> models) {
    return models.map((model) => modelToProduct(model)).toList();
  }

  /// Convert JSON map to ProductModel
  static ProductModel jsonToProductModel(Map<String, dynamic> json) {
    return ProductModel.fromJson(json);
  }

  /// Convert list of JSON maps to ProductModel list
  static List<ProductModel> jsonListToProductModels(
      List<Map<String, dynamic>> jsonList) {
    return jsonList.map((json) => ProductModel.fromJson(json)).toList();
  }
}
