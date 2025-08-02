import 'package:e_commerce_app/add_product.dart';
import 'package:e_commerce_app/detail_product.dart';
import 'package:e_commerce_app/home_page.dart';
import 'package:e_commerce_app/product.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'E-commerce cart',
    initialRoute: '/',
    onGenerateRoute: (settings) {
      if (settings.name == '/') {
        return MaterialPageRoute(builder: (_) => const HomePage());
      }
      if (settings.name == '/detail') {
        final product = settings.arguments as Product;
        return MaterialPageRoute(
            builder: (_) => DetailProduct(
                  product: product,
                ));
      }
      if (settings.name == '/add') {
        final product = settings.arguments is Product
            ? settings.arguments as Product
            : null;
        return MaterialPageRoute(
          builder: (_) => AppProduct(product: product),
        );
      }
      return null;
    },
  ));
}
