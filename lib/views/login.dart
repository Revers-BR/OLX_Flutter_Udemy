import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx_flutter/models/usuario.dart';
import 'package:olx_flutter/views/widget/input_customizado.dart';

class Login extends StatefulWidget {

  const Login({super.key});

  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {

  final TextEditingController _controllerEmail = TextEditingController(text: "reversrivair@gmail.com");
  final TextEditingController _controllerSenha = TextEditingController(text: "1234567");
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _cadastrar      = false;
  String _mensagemErro = "";
  String _textoBotao   = "Entrar";

  void _cadastrarUsuario(ModelUsuario usuario){

    _auth.createUserWithEmailAndPassword(
      email: usuario.email, 
      password: usuario.senha
    ).then((firebaseUser){

    }).catchError(
      (_){
        setState(() => _mensagemErro = "Erro ao cadastrar usuário!");
      }
    );
  }

  void _logarUsuario(ModelUsuario usuario){

    _auth.signInWithEmailAndPassword(
      email: usuario.email, 
      password: usuario.senha
    ).then((firebaseUser){
      Navigator.pushReplacementNamed(context, "/");
    }).catchError(
      (_){
        setState(() => _mensagemErro = "Usuário ou senha inválido!");
      }
    );
  }

  void _validarCampos(){

    String erro = "";

    final email = _controllerEmail.value.text;
    final senha = _controllerSenha.value.text;

    if(email.isNotEmpty && email.contains("@")){
      if(senha.isNotEmpty && senha.length > 6){

        final ModelUsuario usuario = ModelUsuario(
          email: email, 
          senha: senha
        );

        _cadastrar 
          ? _cadastrarUsuario(usuario) 
          : _logarUsuario(usuario);

      }else{
        erro = "Preencha a senha! digite mais de 6 caracteres";
      }
    }else{
       erro = "Preencha o E-mail válido"; 
    }

    setState(() => _mensagemErro = erro);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Image.asset(
                    "imagens/logo.png",
                    width: 200, height: 150,
                    ),
                ),
                InputCustomizado(
                  controller: _controllerEmail, 
                  hintText: "E-mail",
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                ),
                InputCustomizado(
                  controller: _controllerSenha, 
                  hintText: "Senha",
                  obscureText: true,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Logar"),
                    Switch(
                      value: _cadastrar, 
                      onChanged: (value) => setState((){
                        
                        _cadastrar = value;
                        
                        _textoBotao = _cadastrar 
                          ? "Cadastrar" : "Entrar";
                      })
                    ),
                    const Text("Cadastrar")
                  ],
                ),
                FilledButton(
                  onPressed: _validarCampos, 
                  child: Text(_textoBotao)
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Center(
                    child: Text(
                      _mensagemErro, 
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red
                      )
                    ),
                  ) 
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}