class ModelUsuario {

  final String email;
  final String senha;
  String? id;
  String? nome;

  ModelUsuario({
    required this.email,
    required this.senha
  });

  Map<String, dynamic> toMap(){
    
    return {
      "id"    : id,
      "nome"  : nome,
      "email" : email
    };
  }
}