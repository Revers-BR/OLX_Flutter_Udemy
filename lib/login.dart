import 'package:flutter/material.dart';

class Login extends StatefulWidget {

  const Login({super.key});

  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Ola mundo"),
      ),
    );
  }
}