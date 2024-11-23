import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx_flutter/config/config.dart';
import 'package:olx_flutter/models/itens_menu.dart';

class Anuncios extends StatefulWidget {

  const Anuncios({super.key});

  @override
  State<Anuncios> createState() => _Anuncios();
}

class _Anuncios extends State<Anuncios> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<String> itensMenu = [];

  String? _itemSelecionadoEstado;
  String? _itemSelecionadoCategoria;
  List<DropdownMenuItem<String>> _itensDropEstado = [];
  List<DropdownMenuItem<String>> _itensDropCategoria = [];
  
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

  void _carregaritensDropDown(){

    _itensDropCategoria = Configuracoes.getCategorias();
    _itensDropEstado    = Configuracoes.getEstados();
  }

  @override
  void initState() {
    super.initState();
    _carregaritensDropDown();
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

      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                
                Expanded(
                  child:  DropdownButtonHideUnderline(
                    child: Center(
                      child: DropdownButton(
                        items: _itensDropCategoria, 
                        value: _itemSelecionadoCategoria,
                        onChanged: (categoria) => setState(() {
                          _itemSelecionadoCategoria = categoria;
                        }),
                        iconEnabledColor: const Color(0xff9c27b0),
                        style: const TextStyle(
                          fontSize: 22, color: Colors.black
                        ),
                      ),
                    ),
                  ) 
                ),

                Container(
                  color: Colors.grey[200],
                  width: 1, height: 60,
                ),
                
                Expanded(
                  child:  DropdownButtonHideUnderline(
                    child: Center(
                      child: DropdownButton(
                        items: _itensDropEstado, 
                        value: _itemSelecionadoEstado,
                        onChanged: (estado) => setState(() {
                          _itemSelecionadoEstado = estado;
                        }),
                        iconEnabledColor: const Color(0xff9c27b0),
                        style: const TextStyle(
                          fontSize: 22, color: Colors.black
                        ),
                      ),
                    ),
                  ) 
                ),

              ],
            )
          ],
        ),
      ),
    );
  }
}