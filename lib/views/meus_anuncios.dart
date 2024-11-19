import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx_flutter/models/anuncio.dart';
import 'package:olx_flutter/views/widget/item_anuncio.dart';

class MeusAnuncios extends StatefulWidget {

  const MeusAnuncios({super.key});

  @override
  State<MeusAnuncios> createState() => _MeusAnuncios();
}

class _MeusAnuncios extends State<MeusAnuncios> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StreamController<QuerySnapshot> _streamController = StreamController.broadcast();

  String? _idUsuario;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _streamSubscription;

  void _recuperaDadosUsuarioLogado(){

    _idUsuario = _auth.currentUser!.uid;
  }
  
  void _adicionarListenerAnuncios(){

    _recuperaDadosUsuarioLogado();

    _streamSubscription = _firestore
      .collection("meus_anuncios")
      .doc(_idUsuario)
      .collection("anuncios")
      .snapshots()
      .listen(_streamController.add);
  }

  void _removerAnuncio(String idAnuncio ){

    _firestore.collection("meus_anuncios")
      .doc( _idUsuario)
      .collection("anuncios")
      .doc( idAnuncio )
      .delete();
  }

  @override
  void initState() {
    super.initState();
    _adicionarListenerAnuncios();
  }

  @override
  void dispose() {
    super.dispose();
    if(_streamSubscription  != null)_streamSubscription!.cancel();
  }

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

      body: StreamBuilder(
        stream: _streamController.stream, 
        builder: (context, snapshot) {

          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: Column(
                  children: [
                    Text("Carregando anúncios...."),
                    LinearProgressIndicator()
                  ],
                ),
              );
            case ConnectionState.active:
            case ConnectionState.done:

              if(snapshot.hasError) return const Center(child: Text("Erro ao carregar os dados!"));

              final QuerySnapshot<Object?>? querySnapshot = snapshot.data;
              
              return ListView.builder(
                itemCount: querySnapshot!.docs.length,
                itemBuilder: (_, index){

                  final List<DocumentSnapshot> anuncios = querySnapshot.docs.toList();
                  final DocumentSnapshot documentSnapshot = anuncios[index];

                  final ModelAnuncio anuncio = ModelAnuncio.fromDocumentSnapshot(documentSnapshot);
                  
                  return ItemAnuncio(
                    anuncio: anuncio,
                    onPressedRemover: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Confirmar"),
                        content: const Text("Deseja realmente excluir ?"),
                        actions: [
                          
                          IconButton.filled(
                            onPressed: () => Navigator.pop(context), 
                            icon: const Icon(Icons.cancel)
                          ),

                          IconButton.filled(
                            style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red)),
                            onPressed: (){
                              _removerAnuncio( anuncio.id);
                              Navigator.pop(context);
                            }, 
                            icon: const Icon(Icons.delete)
                          ),
                        ],
                      ),
                    ),
                  );
                }
              );
          }
        },
      )
    );
  }
}