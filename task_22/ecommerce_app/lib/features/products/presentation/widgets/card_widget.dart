import 'package:flutter/material.dart';
import '../../doamin/entities/product.dart';

Widget cardWidget(Product product, {required VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap, // use the callback passed from HomePage
    child: Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Card(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
              ),
              clipBehavior: Clip.hardEdge,
              height: 200,
              width: double.infinity,
              child: Image.network(
                product.imageUrl.isNotEmpty
                    ? product.imageUrl
                    : 'https://via.placeholder.com/150',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Row(
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 70, 69, 69),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '\$${product.price}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 70, 69, 69),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
              child: Text(
                'Product',
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 168, 167, 167),
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
