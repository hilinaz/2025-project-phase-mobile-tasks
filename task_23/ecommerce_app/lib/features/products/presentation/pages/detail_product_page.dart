import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../doamin/entities/product.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';

class DetailProduct extends StatefulWidget {
  final Product product;
  const DetailProduct({super.key, required this.product});

  @override
  State<DetailProduct> createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  int? selectedbtn;

  Widget _DescriptionWidget(Product product) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 15),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                product.name,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const Spacer(),
              Icon(Icons.star, color: Colors.amber[600], size: 18),
              Text(
                (product.price != 0.0 ? product.price : 4.0).toString(),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '\$${product.price}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _sizeRange(int start, int end) {
    return Container(
      margin: const EdgeInsets.fromLTRB(23, 0, 20, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Size:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = start; i <= end; i++) ...[
                  SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        backgroundColor: WidgetStateProperty.all(
                          selectedbtn == i
                              ? const Color(0xFF6200EE)
                              : const Color.fromARGB(255, 248, 245, 255),
                        ),
                        foregroundColor: WidgetStateProperty.all(
                          selectedbtn == i ? Colors.white : Colors.black,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedbtn = i;
                        });
                      },
                      child: Text(
                        '$i',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _editProduct() async {
    final updatedProduct = await Navigator.pushNamed(
      context,
      '/add',
      arguments: widget.product,
    );

    if (updatedProduct != null && updatedProduct is Product) {
      context.read<ProductBloc>().add(UpdateProduct(updatedProduct));
    }
  }

  void _deleteProduct() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              context.read<ProductBloc>().add(DeleteProduct(widget.product.id));
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _descriptionWidget(Product product) {
    return Container(
      margin: const EdgeInsets.fromLTRB(23, 10, 20, 15),
      child: Text(
        product.description,
        style: const TextStyle(color: Colors.black, fontSize: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductOperationSuccess) {
            // This is the crucial change. We now pop with a result.
            // The result will be used by the previous page (HomePage) to trigger a refresh.
            Navigator.of(context).pop(true);
          } else if (state is ProductError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    clipBehavior: Clip.hardEdge,
                    height: 250,
                    width: double.infinity,
                    child: Image.network(
                      widget.product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                          'images/placeholder.jpg',
                          fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: 13,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: Center(
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            size: 20,
                          ),
                          color: const Color(0xFF3f51f3),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              _DescriptionWidget(widget.product),
              _sizeRange(39, 50),
              _descriptionWidget(widget.product),
              Container(
                margin: const EdgeInsets.fromLTRB(20, 5, 10, 0),
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      width: 150,
                      decoration: const BoxDecoration(),
                      child: ElevatedButton(
                        onPressed: _deleteProduct,
                        style: ButtonStyle(
                          side: WidgetStateProperty.all(
                            const BorderSide(color: Colors.red),
                          ),
                          backgroundColor:
                              WidgetStateProperty.all(Colors.white),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        child: const Text(
                          'DELETE',
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        ),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 50,
                      width: 150,
                      child: OutlinedButton(
                        onPressed: _editProduct,
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            const Color(0xFF3f51f3),
                          ),
                          foregroundColor: WidgetStateProperty.all(
                            const Color.fromARGB(255, 255, 255, 255),
                          ),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        child: const Text(
                          'UPDATE',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
