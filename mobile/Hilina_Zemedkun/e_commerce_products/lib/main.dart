import 'package:e_commerce_products/home_page.dart';
import 'package:e_commerce_products/add_product.dart';
import 'package:e_commerce_products/detail_product.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_products/product.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => HomePage(),
    },
    onGenerateRoute: (settings) {
      if (settings.name == '/add') {
        final product = settings.arguments as Product?;
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => AppProduct(product: product),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      }
      if (settings.name == '/detail') {
        final product = settings.arguments as Product;
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => DetailProduct(product: product),
          transitionsBuilder: (_, animation, __, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
      }
      return null;
    },
  ));
}
