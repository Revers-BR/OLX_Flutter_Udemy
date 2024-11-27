import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:olx_flutter/config/config.dart';
import 'package:olx_flutter/models/anuncio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

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

  _ligarTelefone( String telefone) async {

    if(await canLaunchUrlString("tel:$telefone")){
      await launchUrlString("tel:$telefone");
    }else{
      debugPrint("Não pode fazer a ligação");
    }
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
        ListView(children: [
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
          ),

          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_anuncio!.preco ?? "",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: tema.primaryColor
                  )
                ),

                Text(_anuncio!.titulo ?? "",
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w400
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(),
                ),

                const Text("Descrição",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),

                Text(_anuncio!.descricao ?? "",
                  style: const TextStyle(
                    fontSize: 18
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(),
                ),

                const Text("Contato",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Text(_anuncio!.telefone ?? "",
                    style: const TextStyle(
                      fontSize: 18
                    ),
                  ),
                )
              ],
            ),
          )
        ]),

        Positioned(
          left: 16, right: 16, bottom: 16,
          child: GestureDetector(
            onTap: () => _ligarTelefone( _anuncio!.telefone! ),
            child: Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: tema.primaryColor,
                borderRadius: BorderRadius.circular(30)
              ),
              child: const Text("Ligar",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
                ),
              ),
            ),
          )
        )
      ]),
    );
  }
}