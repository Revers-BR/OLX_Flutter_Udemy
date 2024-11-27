import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:olx_flutter/models/anuncio.dart';

class DetalhesAnuncio extends StatefulWidget {

  final ModelAnuncio _anuncio;

  const DetalhesAnuncio(this._anuncio, {super.key});

  @override
  State<DetalhesAnuncio> createState() => _DetalhesAnuncio();
}

class _DetalhesAnuncio extends State<DetalhesAnuncio> {

  ModelAnuncio? _anuncio;

  List<Widget> _getListaImagens(){

    final List<String> listaUrlImagens = _anuncio!.fotos.isEmpty
      ? ["https://via.placeholder.com/350x150"]
      : _anuncio!.fotos;

    return listaUrlImagens.map((url){
      return Container(
        height: 250,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(url),
            fit: BoxFit.cover
          )
        ),
      );
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _anuncio = widget._anuncio;
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
      appBar: AppBar(
        title: const Text("Anúncio"),
      ),

      body: Stack(children: [
        SizedBox(
          height: 250,
          child: Swiper(
            itemBuilder: (BuildContext _,int index){
              return _getListaImagens()[index];
            },
            itemCount: _getListaImagens().length,
            pagination: const SwiperPagination(),
            control: const SwiperControl(),
          ),
        )
      ]),
    );
  }
}