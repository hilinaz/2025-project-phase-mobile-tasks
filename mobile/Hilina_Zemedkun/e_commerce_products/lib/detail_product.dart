import 'package:flutter/material.dart';

class DetailProduct extends StatefulWidget {
  const DetailProduct({super.key});

  @override
  State<DetailProduct> createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  int? selectedbtn;
  @override
  Widget build(BuildContext context) {
    Widget _DescriptionWidget(
        String name, String price, double rating, String category) {
      Widget detail = Container(
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 15),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  category,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const Spacer(),
                Icon(Icons.star, color: Colors.amber[600], size: 18),
                Text(
                  '($rating)',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '\$$price',
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

    Widget _sizeRange(int start, int end) {
      Widget sizes = Container(
        margin: const EdgeInsets.fromLTRB(23, 0, 20, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Size:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 15,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int i = start; i <= end; i++) ...[
                    Container(
                      height: 60,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8))),
                              backgroundColor: WidgetStateProperty.all(
                                  selectedbtn == i
                                      ? const Color(0xFF6200EE)
                                      : Color.fromARGB(255, 248, 245, 255)),
                              foregroundColor: WidgetStateProperty.all(
                                  selectedbtn == i
                                      ? Colors.white
                                      : Colors.black)),
                          onPressed: () {
                            setState(() {
                              selectedbtn = i;
                            });
                          },
                          child: Text(
                            '$i',
                            style: const TextStyle(fontSize: 18),
                          )),
                    ),
                    const SizedBox(
                      width: 10,
                    )
                  ]
                ],
              ),
            )
          ],
        ),
      );
      return sizes;
    }

    Widget _descriptionWidget(String description) {
      Widget descriptionWidget = Container(
        margin: const EdgeInsets.fromLTRB(23, 10, 20, 15),
        child: Text(description,style: TextStyle(color:Colors.black,fontSize: 16),),
      );
      return descriptionWidget;
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)
                      )
                    ),
                    clipBehavior: Clip.hardEdge,
                    height: 250,
                    width: double.infinity,
                    child: Image.asset(
                      'images/product.jpg',
                      fit: BoxFit.cover,
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
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back_ios,
                              size: 20,
                            ),
                            color:  const Color(0xFF3f51f3))
                          ),
                        ),
                      )
                ],
              ),
              _DescriptionWidget('Derby Leather', '120', 4.0, 'Men\'s shoe'),
              _sizeRange(39, 50),
              _descriptionWidget( 'Derby leather shoes are a timeless classic, known for their open lacing system '
                      'which makes them a versatile choice for both casual and formal wear. '
                      'Crafted from high-quality leather, these shoes offer exceptional comfort '
                      'and durability. Their elegant design and sturdy construction ensure '
                      'they will be a staple in your wardrobe for years to come. Perfect for '
                      'daily wear or special occasions.'),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 5, 10, 0),
              child: Row(
                children: [
                  
    Container(
                        height: 50,
                        width: 150,
                        decoration: const BoxDecoration(),
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            'DELETE',
                            style: TextStyle(fontSize: 16, color: Colors.red),
                          ),
                          style: ButtonStyle(
                            side: WidgetStateProperty.all(BorderSide(
                              color: Colors.red
                            ),) ,
                             
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.white),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              )),
                        )),
                        const Spacer(),
                        Container(
                        height: 50,
                        width: 150,
                       
                        child: OutlinedButton(
                          onPressed: () {},
                          child: Text(
                            'UPDATE',
                            style: const TextStyle(fontSize: 16),
                          ),
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                  const Color(0xFF3f51f3)),
                              foregroundColor: WidgetStateProperty.all(
                                  const Color.fromARGB(255, 255, 255, 255)),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              )),
                        )),
                        const SizedBox(height: 100,)
                                
                ],
              ),
            )
        
            ],
          ),
        ),
      ),
    );
  }
}
