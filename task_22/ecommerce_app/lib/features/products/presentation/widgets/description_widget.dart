import 'package:flutter/material.dart';

import '../../doamin/entities/product.dart';
Widget DescriptionWidget(Product product) {
  Widget detail = Container(
    margin: const EdgeInsets.fromLTRB(20, 10, 20, 15),
    child: Column(
      children: [
        const SizedBox(
          height: 20,
        ),

            const Text(
            'Product',
              style: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 52, 42, 42),
              ),
            ),
           
          
        
        const SizedBox(
          height: 15,
        ),
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
        const SizedBox(
          height: 10,
        )
      ],
    ),
  );
  return detail;
}

Widget descriptionWidget(Product product) {
  Widget descriptionWidget = Container(
    margin: const EdgeInsets.fromLTRB(23, 10, 20, 15),
    child: Text(
      product.description,
      style: const TextStyle(color: Colors.black, fontSize: 16),
    ),
  );
  return descriptionWidget;
}
