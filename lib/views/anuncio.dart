import 'dart:async';
import 'dart:io';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx_flutter/models/anuncio.dart';
import 'package:olx_flutter/views/widget/input_customizado.dart';
import 'package:validadores/Validador.dart';

class Anuncio extends StatefulWidget {

  const Anuncio({super.key});

  @override
  State<Anuncio> createState() => _Anuncio();
}

class _Anuncio extends State<Anuncio> {

  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final GlobalKey<FormState> _formKey  = GlobalKey<FormState>();

  final TextEditingController _controllerTitulo = TextEditingController();
  final TextEditingController _controllerPreco = TextEditingController();
  final TextEditingController _controllerTelefone = TextEditingController();
  final TextEditingController _controllerDescricao = TextEditingController();

  final List<File> _imagens = [];
  final List<DropdownMenuItem<String>> _itensDropEstados = [];
  final List<DropdownMenuItem<String>> _itensDropCategorias = [];

  BuildContext? _dialogContext;

  String _msgErro = "";
  bool _carregando = false;
  late ModelAnuncio _anuncio;
  String? _itemSelecionadoEstado;
  String? _itemSelecionadoCategoria;

  StreamSubscription<TaskSnapshot>? _streamSubscriptionUpload;
  void _selecionarImagemGaleria() async {

    final XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if(xFile != null){
      final File imagemSelecionado = File(xFile.path);

      setState(() => _imagens.add(imagemSelecionado));
    }
  }

  void _carregarItensDropdown(){

    for (var estado in Estados.listaEstadosSigla) {
      _itensDropEstados.add(
        DropdownMenuItem(
          value: estado,
          child: Text(estado),
        )
      );
    }

    _itensDropCategorias.addAll(const [
      DropdownMenuItem(value: "auto",   child: Text("Automóvel")),
      DropdownMenuItem(value: "eletro", child: Text("Eletrônicos")),
      DropdownMenuItem(value: "imovel", child: Text("Imóvel")),
      DropdownMenuItem(value: "moda",   child: Text("Moda")),
    ]);
  }

  void _salvarAnuncio() {

    _abrirDialog();

    //_uploadImagens();

    final String idUsuario = _auth.currentUser!.uid;
    
    _firestore.collection("meus_anuncios")
      .doc( idUsuario )
      .collection("anuncios")
      .doc( _anuncio.id )
      .set( _anuncio.toMap() )
      .then((_){

        Navigator.pop(_dialogContext!);

        Navigator.pop(context);
      });
        
  }

  void _abrirDialog(){

    showDialog(
      barrierDismissible: false,
      context: _dialogContext!, 
      builder: (_) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text("Salvando anúncio...")
            ],
          ),
        );
      },
    );
  }

  void _uploadImagens() {

    setState(() => _carregando = true);

    final Reference pastaRaiz = _storage.ref();

    for (var imagem in _imagens) {
      
      final nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();

      final Reference arquivo = pastaRaiz
        .child("meus_arquivos")
        .child( _anuncio.id )
        .child( "$nomeImagem.jpg" );

        final UploadTask uploadTask = arquivo.putFile( imagem );

        _streamSubscriptionUpload = uploadTask.snapshotEvents.listen((snapshot) {
          switch (snapshot.state) {
            case TaskState.canceled:
            case TaskState.error:
            case TaskState.paused:
              setState(() {
                _carregando = false;
                _msgErro = "erro ao fazer upload das imagens";
              });
              break;
            case TaskState.running:
              setState(() => _carregando = true);
              break;
            case TaskState.success:
              snapshot.ref.getDownloadURL().then((url){
                _anuncio.fotos.add( url );
                setState(() => _carregando = false);
              });
          }
        })..onError((error){
          setState(() {
                _carregando = false;
                _msgErro = "erro ao fazer upload das imagens";
              });
        });
    }

  }

  @override
  void initState() {
    super.initState();
    _carregarItensDropdown();
    _anuncio = ModelAnuncio();
  }

  @override
  void dispose() {
    super.dispose();
    if(_streamSubscriptionUpload != null)_streamSubscriptionUpload!.cancel();
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
                  // validator: (imagens) {
                  //   if(imagens!.isEmpty)return "Necessário selecionar uma imagem!";
                  //   return null;
                  // },
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
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: DropdownButtonFormField(
                        onSaved: (estado) => _anuncio.estado = estado,
                        value: _itemSelecionadoEstado,
                        hint: Text("Estados"),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20
                        ),
                        items: _itensDropEstados,
                        validator: (value) => Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório!")
                          .valido(value),
                        onChanged: (value) {
                          setState(() {
                            _itemSelecionadoEstado = value;
                          });
                        },
                      ),
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: DropdownButtonFormField(
                        onSaved: (categoria) => _anuncio.categoria = categoria,
                        value: _itemSelecionadoCategoria,
                        hint: Text("Categorias"),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20
                        ),
                        items: _itensDropCategorias,
                        validator: (value) => Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório!")
                          .valido(value),
                        onChanged: (value) {
                          setState(() {
                            _itemSelecionadoCategoria = value;
                          });
                        },
                      ),
                    ),
                  ),
                ]),

                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: InputCustomizado(
                    onSaved: (titulo) => _anuncio.titulo = titulo,
                    controller: _controllerTitulo, 
                    hintText: "Titulo",
                    validator: (valor) {
                      return Validador()
                        .add(Validar.OBRIGATORIO, msg: "Campo obrigatório!")
                        .valido(valor);
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: InputCustomizado(
                    onSaved: (preco) => _anuncio.preco = preco,
                    controller: _controllerPreco, 
                    hintText: "Preço",
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CentavosInputFormatter(moeda: true)
                    ],
                    validator: (valor) {
                      return Validador()
                        .add(Validar.OBRIGATORIO, msg: "Campo obrigatório!")
                        .valido(valor);
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: InputCustomizado(
                    onSaved: (telefone) => _anuncio.telefone = telefone,
                    controller: _controllerTelefone, 
                    hintText: "Telefone",
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter()
                    ],
                    validator: (valor) {
                      return Validador()
                        .add(Validar.OBRIGATORIO, msg: "Campo obrigatório!")
                        .valido(valor);
                    },
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: InputCustomizado(
                    onSaved: (descricao) => _anuncio.descricao = descricao,
                    controller: _controllerDescricao, 
                    hintText: "Descrição (200 caracteres)",
                    maxLines: null,
                    validator: (valor) {
                      return Validador()
                        .add(Validar.OBRIGATORIO, msg: "Campo obrigatório!")
                        .maxLength(200, msg: "Máximo de 200 caracteres")
                        .valido(valor);
                    },
                  ),
                ),

                FilledButton(
                  onPressed: (){
                    if(_formKey.currentState!.validate()){

                      _formKey.currentState!.save();

                      _dialogContext = context;

                      _salvarAnuncio();
                    }
                  }, 
                  child: const Text("Cadastrar Anúncio")
                ),

                _carregando ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: LinearProgressIndicator(),
                )  : Container(),

                _msgErro.isNotEmpty ? Padding(
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: Text(_msgErro, style: const TextStyle(color: Colors.red)),
                  ),
                ) : Container()
              ]
            )
          ),
        ),
      ),
    );
  }
}