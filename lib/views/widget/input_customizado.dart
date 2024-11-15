import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputCustomizado extends StatelessWidget {

  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final bool autofocus;
  final TextInputType keyboardType;
  final int? maxLines;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;

  const InputCustomizado({
    super.key,

    required this.controller,
    required this.hintText,

    this.maxLines,
    this.validator,
    this.inputFormatters,
    this.autofocus = false,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      autofocus: autofocus,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 20),
      inputFormatters: inputFormatters,
      validator: validator,
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