import 'package:flutter/material.dart';

Widget buildTextField(String label, String hint,TextEditingController controller, {bool obscure = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style:
            const TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
      ),
      const SizedBox(height: 6),
      TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: const Color(0xFFF7F7F7),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    ],
  );
}
