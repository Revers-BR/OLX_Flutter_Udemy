import 'package:flutter/material.dart';
import 'package:olx_flutter/views/login.dart';
import 'package:olx_flutter/views/anuncio.dart';
import 'package:olx_flutter/views/anuncios.dart';
import 'package:olx_flutter/models/anuncio.dart';
import 'package:olx_flutter/views/meus_anuncios.dart';
import 'package:olx_flutter/views/detalhes_anuncio.dart';

class RouteGenerator {

  static Route<Widget> generateRoute(RouteSettings settings){

    final args = settings.arguments;

    Widget view = const Anuncios();

    switch (settings.name) {
      case "/":
        view = const Anuncios();
        break;
      case "/login":
        view = const Login();
        break;
      case "/novo-anuncio":
        view = const Anuncio();
        break;
      case "/meus-anuncios":
        view = const MeusAnuncios();
        break;
      case "/detalhes-anuncios":
        view = DetalhesAnuncio(args as ModelAnuncio);
        break;
      default:
        return erroRota();
    }

    return MaterialPageRoute(
      builder: (_) => view
    );
  }

  static Route<Widget> erroRota(){
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text("Tela não encontrada!"),
        ),
        body: const Center(
          child: Text("Tela não encontrada!"),
        ),
      )
    );
  }
}