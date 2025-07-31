import 'package:flutter/material.dart';
import 'package:e_commerce_app/product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> productList = [];
  @override
  void initState() {
    super.initState();
    Product product = Product(
      name: 'Derby Leather Shoes',
      description: '''
 Derby Leather Shoes,
Derby leather shoes are a timeless classic, known for their open lacing system
which makes them a versatile choice for both casual and formal wear.
Crafted from high-quality leather, these shoes offer exceptional comfort
and durability. Their elegant design and sturdy construction ensure
they will be a staple in your wardrobe for years to come. Perfect for
daily wear or special occasions.
''',
      category: 'Men\'s shoe',
      price: 120,
    );

    productList.add(product);
  }

 Future<void> _deleteOrEdit(int index) async {
    final result = await Navigator.pushNamed(
      context,
      '/detail',
      arguments: productList[index],
    );

    if (result == true) {
      setState(() {
        productList.removeAt(index);
      });
    } else if (result is Product) {
      setState(() {
        productList[index] = result;
      });
    }
  }

  Widget _cardWidget(Product product, int index) {
    Widget cards = GestureDetector(
      onTap: () => _deleteOrEdit(index),
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
                child: Image.asset(
                  product.imagePath.isNotEmpty
                      ? product.imagePath
                      : 'images/product.jpg',
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
              const SizedBox(
                height: 6,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
                child: Row(
                  children: [
                    Text(
                      product.category,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 168, 167, 167),
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.star, color: Colors.amber[600], size: 23),
                    Text(
                      (product.rating != 0.0 ? product.rating : 4.0).toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 168, 167, 167),
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

    return cards;
  }

  Future<void> _addProduct() async {
    final newproduct = await Navigator.pushNamed(context, '/add') as Product?;
    if (newproduct != null) {
      setState(() {
        productList.add(newproduct);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  SizedBox(
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
            ListView.builder(
                itemCount: productList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return _cardWidget(productList[index], index);
                }),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addProduct,
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
