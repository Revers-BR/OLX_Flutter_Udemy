import 'package:flutter/material.dart';
import 'package:olx_flutter/views/anuncios.dart';
import 'package:olx_flutter/views/login.dart';

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
      // case "/meus-anuncios":
      //   break;
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