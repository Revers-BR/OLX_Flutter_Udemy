import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx_flutter/models/itens_menu.dart';

class Anuncios extends StatefulWidget {

  const Anuncios({super.key});

  @override
  State<Anuncios> createState() => _Anuncios();
}

class _Anuncios extends State<Anuncios> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<String> itensMenu = [];
  
  void _escolhaMenuItem(String itemEscolhido){

    switch (itemEscolhido) {
      case ItensMenu.meusAnuncios:
        Navigator.pushNamed(context, "/meus-anuncios");
        break;
      case ItensMenu.entrarCadastrar:
        Navigator.pushReplacementNamed(context, "/login");
        break;
      case ItensMenu.deslogar:
        _deslogarUsuario();
        break;
    }
  }

  void _deslogarUsuario() {

    _auth.signOut()
      .then(
        (_) => Navigator.pushReplacementNamed(context, "/")
      );
  }

  void _verificarUsuarioLogado(){

    final User? usuarioLogado = _auth.currentUser;

    if(usuarioLogado == null){
      itensMenu = [ItensMenu.entrarCadastrar];
    }else{
      itensMenu = [
        ItensMenu.meusAnuncios,
        ItensMenu.deslogar
      ];
    }
  }

  @override
  void initState() {
    super.initState();
    _verificarUsuarioLogado();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OLX"),
        elevation: 0,
        actions: [
          PopupMenuButton(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context) {
              return itensMenu.map((item){
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item)
                );
              }).toList();
            },
          )
        ],
      ),
    );
  }
}