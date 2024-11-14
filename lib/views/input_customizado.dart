import 'package:flutter/material.dart';

class InputCustomizado extends StatelessWidget {

  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final bool autofocus;
  final TextInputType keyboardType;

  const InputCustomizado({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.autofocus = false,
    this.keyboardType = TextInputType.text
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      autofocus: autofocus,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 20),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6)
        )
      ),
    );
  }
}