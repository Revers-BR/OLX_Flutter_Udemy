import 'package:flutter/material.dart';

class Anuncio extends StatefulWidget {

  const Anuncio({super.key});

  @override
  State<Anuncio> createState() => _Anuncio();
}

class _Anuncio extends State<Anuncio> {

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title:  const Text("Novo Anúncio"),
      ),
    );
  }
}