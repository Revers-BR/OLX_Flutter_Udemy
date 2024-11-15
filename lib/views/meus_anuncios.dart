import 'package:flutter/material.dart';

class MeusAnuncios extends StatefulWidget {

  const MeusAnuncios({super.key});

  @override
  State<MeusAnuncios> createState() => _MeusAnuncios();
}

class _MeusAnuncios extends State<MeusAnuncios> {

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Anúncios"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, "/novo-anuncio"),
        child: const Icon(Icons.add),
      ),
    );
  }
}