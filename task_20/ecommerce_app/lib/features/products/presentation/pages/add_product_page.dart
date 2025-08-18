import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../doamin/entities/product.dart';
import '../bloc/product_bloc.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  late Product? product;
  late TextEditingController namecontroller;
  late TextEditingController categorycontroller;
  late TextEditingController pricecontroller;
  late TextEditingController descriptioncontroller;
  bool isUpdate = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    product = ModalRoute.of(context)!.settings.arguments as Product?;
    if (product != null) {
      isUpdate = true;
    }

    namecontroller = TextEditingController(text: product?.name ?? '');
    categorycontroller = TextEditingController();
    pricecontroller =
        TextEditingController(text: product?.price.toString() ?? '');
    descriptioncontroller =
        TextEditingController(text: product?.description ?? '');
  }

  File? selectedImage;

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        selectedImage = File(pickedImage.path);
      });
    }
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
          ),
        ),
        title: const Text('Add Product'),
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is SuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),

            );
            Navigator.of(context).pop(); 
          } else if (state is ErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {

         
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 234, 234, 234),
                          image: selectedImage != null
                              ? DecorationImage(
                                  image: FileImage(selectedImage!),
                                  fit: BoxFit.cover,
                                )
                              : product!= null&& product!.imageUrl.isNotEmpty
                                  ? DecorationImage(
                                      image:
                                          Image.network(product!.imageUrl).image,
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                        ),
                        child: selectedImage == null  &&
                                product == null
                            ? const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image,
                                    color: Color.fromARGB(255, 163, 163, 163),
                                    size: 60,
                                  ),
                                  SizedBox(height: 20),
                                  Text("Upload image",
                                      style: TextStyle(fontSize: 16)),
                                ],
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text('name',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(
                    controller: namecontroller,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      border:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
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
                      border:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
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
                      border:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
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
                      border:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final newProduct = Product(
                          id: isUpdate ? product!.id : '',
                          name: namecontroller.text,
                          description: descriptioncontroller.text,
                          imageUrl: isUpdate
                              ? product!.imageUrl
                              : selectedImage?.path ?? '',
                          price: pricecontroller.text.isNotEmpty
                              ? double.parse(pricecontroller.text)
                              : 0.0,
                        );

                        if (isUpdate) {
                          context
                              .read<ProductBloc>()
                              .add(UpdateProductEvent(product: newProduct));
                        } else {
                          context
                              .read<ProductBloc>()
                              .add(CreateProductEvent(product: newProduct,

                                imageFile: selectedImage,
                              ));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6200EE),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        isUpdate ? 'UPDATE' : 'ADD',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
