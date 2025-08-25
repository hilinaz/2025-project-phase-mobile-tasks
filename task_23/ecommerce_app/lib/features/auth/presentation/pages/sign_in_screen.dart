import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/widgets.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                 Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 34, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF253FE9),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: const Text(
                      'ECOM',
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF253FE9),
                        fontFamily: 'CaveatBrush', // your custom font
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Title
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Sign into your account",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Email Field
                  buildTextField(
                      'Email', 'ex: jon.smith@email.com', emailController),

                  const SizedBox(height: 20),
                  buildTextField(
                      'Password',
                      '********',
                      obscure: true,
                      passwordController),

                  // Password Field

                  const SizedBox(height: 25),

                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is ErrorState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)));
                      } else if (state is SignInState) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Welcome back ${state.user.name}')));
                        Navigator.pushNamed(context, '/home');
                      }
                    },
                    builder: (context, state) {
                      if (state is LoadingState) {
                        return const CircularProgressIndicator();
                      }
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF253FE9),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            final email = emailController.text.trim();
                            final password = passwordController.text.trim();
                            context.read<AuthBloc>().add(SignInEvent(
                                email: email, password: password));
                          },
                          child: const Text(
                            "SIGN IN",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 100),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don’t have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: const Text(
                          "SIGN UP",
                          style: TextStyle(
                            color:  Color(0xFF253FE9),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
