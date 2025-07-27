import 'package:e_commerce_products/product.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> products = [
    Product(
      title: 'Derby Leather Shoes',
      description:
          "Derby leather shoes are a timeless classic, known for their open lacing system which makes them a versatile choice for both casual and formal wear.",
      category: "Men's shoe",
      price: 120.0,
      imagePath: 'images/product.jpg',
    ),
    
  ];

  void _navigateToAddProduct([Product? product, int? index]) async {
    final result =
        await Navigator.of(context).pushNamed('/add', arguments: product);
    if (result is Product) {
      setState(() {
        if (index != null) {
          products[index] = result;
        } else {
          products.add(result);
        }
      });
    }
  }

  void _navigateToDetail(Product product, int index) async {
    final result =
        await Navigator.of(context).pushNamed('/detail', arguments: product);
    if (result == 'delete') {
      setState(() {
        products.removeAt(index);
      });
    } else if (result is Product) {
      setState(() {
        products[index] = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _cardWidget() {
      return List.generate(products.length, (index) {
        final product = products[index];
        return GestureDetector(
          onTap: () {
            _navigateToDetail(product, index);
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Card(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                    ),
                    clipBehavior: Clip.hardEdge,
                    height: 200,
                    width: double.infinity,
                    child: Image.asset(
                      product.imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Row(
                      children: [
                        Text(
                          product.title,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 70, 69, 69),
                          ),
                        ),
                        Spacer(),
                        Text(
                          '\$${product.price}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 70, 69, 69),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
                    child: Row(
                      children: [
                        Text(
                          product.category,
                          style: TextStyle(
                            fontSize: 16,
                            color: const Color.fromARGB(255, 168, 167, 167),
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.star, color: Colors.amber[600], size: 23),
                        Text(
                          '(4.0)',
                          style: TextStyle(
                            fontSize: 18,
                            color: const Color.fromARGB(255, 168, 167, 167),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 5, 10, 0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              height: 50,
              margin: const EdgeInsets.only(top: 40, bottom: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        color: const Color(0xFFcccccc)),
                  ),
                  Container(
                    height: 50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'July 14 2023',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text.rich(TextSpan(
                            text: 'Hello,',
                            style: TextStyle(fontSize: 18),
                            children: [
                              TextSpan(
                                text: 'Yohannes',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ]))
                      ],
                    ),
                  ),
                  const Spacer(),
                  OutlinedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                          side: WidgetStateProperty.all(
                            const BorderSide(
                                color: Color.fromARGB(255, 208, 207, 207)),
                          ),
                          minimumSize:
                              WidgetStateProperty.all(const Size(10, 50)),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11)))),
                      child: const Icon(
                        Icons.notifications_none,
                        size: 30,
                      ))
                ],
              ),
            ),
            const Text("Available Products",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
            const SizedBox(
              height: 15,
            ),
            ..._cardWidget()
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddProduct();
        },
        backgroundColor: const Color(0xFF6200EE),
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
