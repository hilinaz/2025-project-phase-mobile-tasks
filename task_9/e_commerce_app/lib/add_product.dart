import 'package:flutter/material.dart';
import 'package:e_commerce_app/product.dart';

class AppProduct extends StatefulWidget {
  final Product? product;

  const AppProduct({super.key, this.product});

  @override
  State<AppProduct> createState() => _AppProductState();
}

class _AppProductState extends State<AppProduct> {
  late TextEditingController namecontroller;
  late TextEditingController categorycontroller;
  late TextEditingController pricecontroller;
  late TextEditingController descriptioncontroller;
  @override
  void initState() {
    super.initState();
    namecontroller = TextEditingController(text: widget.product?.name ?? '');
    categorycontroller =
        TextEditingController(text: widget.product?.category ?? '');
    pricecontroller =
        TextEditingController(text: widget.product?.price.toString() ?? '');
    descriptioncontroller =
        TextEditingController(text: widget.product?.description ?? '');
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
        title: const Text('Add Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
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
                controller: namecontroller,
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
              const SizedBox(height: 20),
              const Text('category',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: categorycontroller,
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
              const SizedBox(height: 20),
              const Text('price',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: pricecontroller,
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
              const SizedBox(height: 20),
              const Text('description',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: descriptioncontroller,
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
                    Product product = Product(
                        name: namecontroller.text,
                        description: descriptioncontroller.text,
                        category: categorycontroller.text,
                        price: double.parse(pricecontroller.text));
                    Navigator.pop(context, product);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6200EE),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'ADD',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {},
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
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
