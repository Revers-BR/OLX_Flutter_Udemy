import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class Anuncio extends StatefulWidget {

  const Anuncio({super.key});

  @override
  State<Anuncio> createState() => _Anuncio();
}

class _Anuncio extends State<Anuncio> {

  final GlobalKey<FormState> _formKey  = GlobalKey<FormState>();

  final List<File> _imagens = [];

  void _selecionarImagemGaleria() async {

    final XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if(xFile != null){
      final File imagemSelecionado = File(xFile.path);

      setState(() => _imagens.add(imagemSelecionado));
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title:  const Text("Novo Anúncio"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FormField(
                  initialValue: _imagens,
                  validator: (imagens) {
                    if(imagens!.isEmpty)return "Necessário selecionar uma imagem!";
                    return null;
                  },
                  builder: (field) {
                    return Column(children: [
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _imagens.length + 1,
                          itemBuilder: (context, index) {
                            if(index == _imagens.length){
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: GestureDetector(
                                  onTap: _selecionarImagemGaleria,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey[400],
                                    radius: 50,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_a_photo,
                                          size: 40,
                                          color: Colors.grey[100],
                                        ),
                                        Text(
                                          "Adicionar",
                                          style: TextStyle(
                                            color: Colors.grey[100]
                                          ),
                                        )
                                      ]
                                    ),
                                  ),
                                ),
                              );
                            }

                            if(_imagens.isNotEmpty){

                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: GestureDetector(
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.file( _imagens[index]),
                                          TextButton(
                                            style: const ButtonStyle(
                                              foregroundColor: MaterialStatePropertyAll(Colors.red)
                                            ),
                                            onPressed: (){
                                              setState(() {
                                                _imagens.removeAt(index);
                                              });
                                              
                                              Navigator.of(context).pop();
                                            }, 
                                            child: const Text("Excluir")
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage: FileImage( _imagens[index] ),
                                    child: Container(
                                      alignment: Alignment.bottomRight,
                                      //color: Color.fromRGBO(255, 255, 255, 0.4),
                                      child: const Icon(
                                        Icons.delete_outline, 
                                        color: Colors.redAccent
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }

                            return Container();
                          },
                        ),
                      ),
                      if(field.hasError) Text(
                        "[${field.errorText}]",
                        style: const TextStyle(
                          color: Colors.red, fontSize: 14
                        ),
                      ),
                    ]);
                  },
                ),
                Row(children: [
                  Text("Estado"),
                  Text("Categoria")
                ]),
                Text("Caixa de textos"),
                FilledButton(
                  onPressed: (){
                    if(_formKey.currentState!.validate()){

                    }
                  }, 
                  child: const Text("Cadastrar Anúncio")
                )
              ]
            )
          ),
        ),
      ),
    );
  }
}