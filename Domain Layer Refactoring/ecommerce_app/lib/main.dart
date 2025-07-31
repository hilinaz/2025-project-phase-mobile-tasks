import 'package:flutter/material.dart';
import 'domain/entities/product.dart';
import 'domain/usecases/view_all_products_usecase.dart';
import 'domain/usecases/view_product_usecase.dart';
import 'domain/usecases/create_product_usecase.dart';
import 'domain/usecases/update_product_usecase.dart';
import 'domain/usecases/delete_product_usecase.dart';
import 'domain/usecases/usecase.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eCommerce App - Domain Layer Refactoring',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ProductManagementPage(),
    );
  }
}

class ProductManagementPage extends StatefulWidget {
  const ProductManagementPage({super.key});

  @override
  State<ProductManagementPage> createState() => _ProductManagementPageState();
}

class _ProductManagementPageState extends State<ProductManagementPage> {
  final List<Product> _products = [];

  late final ViewAllProductsUsecase _viewAllProductsUsecase;
  late final ViewProductUsecase _viewProductUsecase;
  late final CreateProductUsecase _createProductUsecase;
  late final UpdateProductUsecase _updateProductUsecase;
  late final DeleteProductUsecase _deleteProductUsecase;

  @override
  void initState() {
    super.initState();
    _viewAllProductsUsecase = ViewAllProductsUsecase(_products);
    _viewProductUsecase = ViewProductUsecase(_products);
    _createProductUsecase = CreateProductUsecase(_products);
    _updateProductUsecase = UpdateProductUsecase(_products);
    _deleteProductUsecase = DeleteProductUsecase(_products);

    _addSampleProducts();
  }

  void _addSampleProducts() {
    final product1 = Product(
      id: '1',
      name: 'Smartphone',
      description: 'Latest smartphone with advanced features',
      price: 599.99,
      imageUrl: 'https://example.com/smartphone.jpg',
    );

    final product2 = Product(
      id: '2',
      name: 'Laptop',
      description: 'High-performance laptop for work and gaming',
      price: 1299.99,
      imageUrl: 'https://example.com/laptop.jpg',
    );

    _createProductUsecase(product1);
    _createProductUsecase(product2);
  }

  void _addNewProduct() {
    final newProduct = Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'New Product',
      description: 'A new product description',
      price: 99.99,
      imageUrl: 'https://example.com/new-product.jpg',
    );

    _createProductUsecase(newProduct);
    setState(() {});
  }

  void _deleteProduct(String id) {
    _deleteProductUsecase(id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Product Management - Domain Layer'),
      ),
      body: FutureBuilder<List<Product>>(
        future: _viewAllProductsUsecase(const NoParams()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data ?? [];

          if (products.isEmpty) {
            return const Center(child: Text('No products available'));
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(product.name),
                  subtitle: Text('${product.description}\n\$${product.price}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteProduct(product.id),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewProduct,
        tooltip: 'Add Product',
        child: const Icon(Icons.add),
      ),
    );
  }
}
