import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../doamin/entities/product.dart';

class ProductForm extends StatefulWidget {
  final Product? product;
  final Function(Product) onSubmit;
  final bool isLoading;

  const ProductForm({
    super.key,
    this.product,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _descriptionController.text = widget.product!.description;
      _priceController.text = widget.product!.price.toString();
      _imageUrlController.text = widget.product!.imageUrl;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id: widget.product?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text),
        imageUrl: _imageUrlController.text.trim(),
      );
      widget.onSubmit(product);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            label: 'Product Name',
            hint: 'Enter product name',
            controller: _nameController,
            validator: Validators.required,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          
          CustomTextField(
            label: 'Description',
            hint: 'Enter product description',
            controller: _descriptionController,
            validator: Validators.required,
            maxLines: 3,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          
          CustomTextField(
            label: 'Price',
            hint: 'Enter product price',
            controller: _priceController,
            validator: Validators.price,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            prefixIcon: const Icon(Icons.attach_money),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          
          CustomTextField(
            label: 'Image URL',
            hint: 'Enter product image URL',
            controller: _imageUrlController,
            validator: Validators.url,
            keyboardType: TextInputType.url,
            prefixIcon: const Icon(Icons.image),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submitForm(),
          ),
          const SizedBox(height: 24),
          
          CustomButton(
            text: widget.product != null ? 'Update Product' : 'Create Product',
            onPressed: _submitForm,
            isLoading: widget.isLoading,
            icon: widget.product != null ? Icons.edit : Icons.add,
          ),
        ],
      ),
    );
  }
} 