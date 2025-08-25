import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../doamin/entities/product.dart';
import '../bloc/product_bloc.dart';
import '../widgets/widget.dart';

class DetailProduct extends StatefulWidget {
  const DetailProduct({super.key});

  @override
  State<DetailProduct> createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  late String prodID;
  late Product product;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    prodID = ModalRoute.of(context)!.settings.arguments as String;
    context.read<ProductBloc>().add(GetSingleProductEvent(productId: prodID));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is SuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );

       
          if (state.message.contains('deleted')) {
            Navigator.pop(context, true);
          }
        } else if (state is ErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 255, 254, 254),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        clipBehavior: Clip.hardEdge,
                        height: 250,
                        width: double.infinity,
                        child: BlocBuilder<ProductBloc, ProductState>(
                          builder: (context, state) {
                            if (state is ErrorState) {
                              return Center(child: Text(state.message));
                            } else if (state is LoadingState) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state is LoadedSingleProductState) {
                              return Image.network(
                                state.product.imageUrl,
                                fit: BoxFit.cover,
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                      ),
                      Positioned(
                        top: 20,
                        left: 13,
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                size: 20,
                              ),
                              color: const Color(0xFF3f51f3),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

      
                  BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                      if (state is ErrorState) {
                        return Center(child: Text(state.message));
                      } else if (state is LoadingState) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is LoadedSingleProductState) {
                        product = state.product;
                        return Column(
                          children: [
                            DescriptionWidget(state.product),
                            descriptionWidget(state.product),
                          ],
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),

                 
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 5, 10, 0),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 50,
                          width: 150,
                          child: ElevatedButton(
                            onPressed: () {
                              context
                                  .read<ProductBloc>()
                                  .add(DeleteProductEvent(productId: prodID));
                            
                            },
                            style: ButtonStyle(
                              side: MaterialStateProperty.all(
                                const BorderSide(color: Colors.red),
                              ),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            child: const Text(
                              'DELETE',
                              style: TextStyle(fontSize: 16, color: Colors.red),
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          height: 50,
                          width: 150,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/add_product',
                                  arguments: product);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                const Color(0xFF3f51f3),
                              ),
                              foregroundColor: MaterialStateProperty.all(
                                Colors.white,
                              ),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            child: const Text(
                              'UPDATE',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
