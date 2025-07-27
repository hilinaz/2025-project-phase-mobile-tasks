import 'package:e_commerce_products/detail_product.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_products/add_product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> _cardWidget(int count) {
      List<Widget> cards = List.generate(count, (index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => DetailProduct()));
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
                      'images/product.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: const Row(
                      children: [
                        Text(
                          'Derby Leather Shoes',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 70, 69, 69),
                          ),
                        ),
                        Spacer(),
                        Text(
                          '\$120',
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
                          "Men's shoe",
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
      return cards;
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
            ..._cardWidget(6)
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AppProduct()));
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
