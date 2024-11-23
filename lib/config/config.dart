import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';

const Color _backgroundColor = Color(0xff9c27b0);

final tema = ThemeData(
  primaryColor: _backgroundColor,
  appBarTheme: const AppBarTheme(
    foregroundColor: Colors.white,
    backgroundColor: _backgroundColor
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: _backgroundColor,
    foregroundColor: Colors.white
  ),
  filledButtonTheme: const FilledButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(_backgroundColor)
    )
  )
);

class Configuracoes {

  static List<DropdownMenuItem<String>> getCategorias(){

    final List<DropdownMenuItem<String>> itensDropCategorias = [];

    itensDropCategorias.addAll(const [
      DropdownMenuItem(value: null,   child: Text(
        "Categorias",
        style: TextStyle(
          color: Color(0xff9c27b0)
        ),
      )),
      DropdownMenuItem(value: "auto",   child: Text("Automóvel")),
      DropdownMenuItem(value: "eletro", child: Text("Eletrônicos")),
      DropdownMenuItem(value: "imovel", child: Text("Imóvel")),
      DropdownMenuItem(value: "moda",   child: Text("Moda")),
    ]);

    return itensDropCategorias;
  }

  static List<DropdownMenuItem<String>> getEstados(){

    final List<DropdownMenuItem<String>> itensDropEstados = [];

    itensDropEstados.add(
      const DropdownMenuItem(value: null,   child: Text(
        "Estados",
        style: TextStyle(
          color: Color(0xff9c27b0)
        ),
      )),
    );

    for (var estado in Estados.listaEstadosSigla) {
      itensDropEstados.add(
        DropdownMenuItem(
          value: estado,
          child: Text(estado),
        )
      );
    }

    return itensDropEstados;
  }
}