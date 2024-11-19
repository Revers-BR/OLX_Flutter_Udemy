import 'package:cloud_firestore/cloud_firestore.dart';

class ModelAnuncio {

  late final String id;
  late final List<String> fotos;
  
  String? estado;
  String? categoria;
  String? titulo;
  String? preco;
  String? telefone;
  String? descricao;

  final FirebaseFirestore _storage = FirebaseFirestore.instance;

  ModelAnuncio(){

    CollectionReference anuncios = _storage.collection("meus_anuncios");
    
    id = anuncios.doc().id;

    fotos = [];
  }

  Map<String, dynamic> toMap(){

    return {
      "id": id,
      "estado": estado,
      "categoria": categoria,
      "titulo": titulo,
      "preco": preco,
      "telefone": telefone,
      "descricao": descricao,
      "fotos": fotos,
    };
  }
}