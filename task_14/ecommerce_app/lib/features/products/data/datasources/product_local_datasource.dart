import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exception.dart';
import '../models/product_model.dart';

abstract class ProductLocalDatasource {
  Future<ProductModel> getProduct();
  Future<void> cacheProduct(ProductModel productModel);

  Future<void> deleteProduct(String id) async {}

  Future getProductById(String id) async {}

  Future getAllProducts() async {}
}




const CACHED_PRODUCTS = 'CACHED_PRODUCTS';

class ProductLocalDatasourceImpl implements ProductLocalDatasource {
  final SharedPreferences sharedPreferences;

  ProductLocalDatasourceImpl({required this.sharedPreferences});

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final jsonString = sharedPreferences.getString(CACHED_PRODUCTS);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((item) => ProductModel.fromJson(item)).toList();
    } else {
      throw CacheException();
    }
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    final allProducts = await getAllProducts();
    try {
      return allProducts.firstWhere((product) => product.id == id);
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheProduct(ProductModel product) async {
    final allProducts = await getAllProducts().catchError((_) => []);
    final updatedProducts = [...allProducts.where((p) => p.id != product.id), product];
    final jsonList = updatedProducts.map((product) => product.toJson()).toList();
    sharedPreferences.setString(CACHED_PRODUCTS, json.encode(jsonList));
  }

  @override
  Future<void> deleteProduct(String id) async {
    final allProducts = await getAllProducts().catchError((_) => []);
    final updatedProducts = allProducts.where((product) => product.id != id).toList();
    final jsonList = updatedProducts.map((product) => product.toJson()).toList();
    sharedPreferences.setString(CACHED_PRODUCTS, json.encode(jsonList));
  }
  
  @override
  Future<ProductModel> getProduct() {
    // TODO: implement getProduct
    throw UnimplementedError();
  }
}

