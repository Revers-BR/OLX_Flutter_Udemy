import 'package:flutter/material.dart';

class MeusAnuncios extends StatefulWidget {

  const MeusAnuncios({super.key});

  @override
  State<MeusAnuncios> createState() => _MeusAnuncios();
}

class _MeusAnuncios extends State<MeusAnuncios> {

  final GlobalKey _formKey  = GlobalKey<FormState>();

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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: const Column(children: [

            ],)
          ),
        ),
      ),
    );
  }
}