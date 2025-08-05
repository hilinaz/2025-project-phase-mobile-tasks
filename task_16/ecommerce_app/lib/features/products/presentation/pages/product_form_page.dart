import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection_container.dart';
import '../bloc/products_bloc.dart';
import '../widgets/product_form.dart';
import '../../doamin/entities/product.dart';

class ProductFormPage extends StatelessWidget {
  final Product? product;

  const ProductFormPage({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProductsBloc>(),
      child: ProductFormView(product: product),
    );
  }
}

class ProductFormView extends StatelessWidget {
  final Product? product;

  const ProductFormView({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    final isEditing = product != null;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Product' : 'Add Product'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocConsumer<ProductsBloc, ProductsState>(
        listener: (context, state) {
          if (state is ProductOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is ProductOperationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: ProductForm(
              product: product,
              onSubmit: (product) {
                if (isEditing) {
                  context.read<ProductsBloc>().add(UpdateProduct(product: product));
                } else {
                  context.read<ProductsBloc>().add(CreateProduct(product: product));
                }
              },
              isLoading: state is ProductOperationLoading,
            ),
          );
        },
      ),
    );
  }
} 