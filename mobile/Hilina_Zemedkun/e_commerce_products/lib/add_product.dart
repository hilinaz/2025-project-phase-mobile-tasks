import 'package:flutter/material.dart';
import 'package:e_commerce_products/product.dart';

class AppProduct extends StatefulWidget {
  final Product? product;
  const AppProduct({Key? key, this.product}) : super(key: key);

  @override
  State<AppProduct> createState() => _AppProductState();
}

class _AppProductState extends State<AppProduct> {
  late TextEditingController titleController;
  late TextEditingController categoryController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.product?.title ?? '');
    categoryController =
        TextEditingController(text: widget.product?.category ?? '');
    priceController = TextEditingController(
        text: widget.product?.price != null
            ? widget.product!.price.toString()
            : '');
    descriptionController =
        TextEditingController(text: widget.product?.description ?? '');
  }

  @override
  void dispose() {
    titleController.dispose();
    categoryController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF6200EE),
            )),
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 234, 234, 234),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image,
                        color: Color.fromARGB(255, 163, 163, 163),
                        size: 60,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Upload image", style: TextStyle(fontSize: 16))
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text('name', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
              const SizedBox(height: 20),
              const Text('category',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: categoryController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
              const SizedBox(height: 20),
              const Text('price',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
              const SizedBox(height: 20),
              const Text('description',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: descriptionController,
                maxLines: 6,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final product = Product(
                      title: titleController.text,
                      description: descriptionController.text,
                      category: categoryController.text,
                      price: double.tryParse(priceController.text) ?? 0.0,
                      imagePath: 'images/product.jpg',
                    );
                    Navigator.of(context).pop(product);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6200EE),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    widget.product == null ? 'ADD' : 'UPDATE',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop('delete');
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'DELETE',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
