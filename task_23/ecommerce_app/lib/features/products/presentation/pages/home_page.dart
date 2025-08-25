import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart' as auth;
import '../bloc/product_bloc.dart' as prod;
import '../widgets/widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<prod.ProductBloc>().add(prod.LoadAllProductEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 5, 10, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50,
                margin: const EdgeInsets.only(top: 40, bottom: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        color: const Color(0xFFcccccc),
                      ),
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
                          const Text.rich(
                            TextSpan(
                              text: 'Hello,',
                              style: TextStyle(fontSize: 18),
                              children: [
                                TextSpan(
                                  text: ' Guest',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/chats');
                      },
                      style: ButtonStyle(
                        side: WidgetStateProperty.all(
                          const BorderSide(
                            color: Color.fromARGB(255, 208, 207, 207),
                          ),
                        ),
                        minimumSize:
                            WidgetStateProperty.all(const Size(10, 40)),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      child: const Icon(
                        Icons.message_outlined,
                        size: 28,
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, size: 28),
                      onSelected: (value) {
                        if (value == 'logout') {
                          context
                              .read<auth.AuthBloc>()
                              .add(auth.SignOutEvent());
                          Navigator.pushReplacementNamed(context, '/signin');
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'logout',
                          child: Text('Logout'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Text(
                "Available Products",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              const SizedBox(height: 15),

              /// 🔽 Product Bloc
              BlocBuilder<prod.ProductBloc, prod.ProductState>(
                builder: (context, state) {
                  if (state is prod.LoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is prod.ErrorState) {
                    return Center(child: Text(state.message));
                  } else if (state is prod.LoadedAllProductsState) {
                    if (state.products.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            "No products available yet.",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return cardWidget(
                          product,
                          onTap: () {
                            final productBloc =
                                context.read<prod.ProductBloc>();
                            Navigator.pushNamed(
                              context,
                              '/detail',
                              arguments: product.id,
                            ).then((_) {
                              productBloc.add(prod.LoadAllProductEvent());
                            });
                          },
                        );
                      },
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_product');
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
