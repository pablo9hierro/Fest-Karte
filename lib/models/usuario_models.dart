import 'dart:io';
class Usuario {
  final String id;
  String avatarUrl;
  String nome;
  String email;

  Usuario({
    required this.id,
    required this.avatarUrl,
    required this.nome,
    required this.email,
  });

  // Método para receber e configurar o e-mail
  void receberEmail(novoEmail) {
    email = stdin.readLineSync()!;
  }

  // Método para receber e configurar o nome
  void receberNome(novoNome) {
    nome = stdin.readLineSync()!;
  }

  // Método para receber e configurar a URL do avatar
  void receberAvatarUrl(novoUrl) {
    avatarUrl = stdin.readLineSync()!;
  }

  bool validarEmail(String novoEmail) {
    return novoEmail == email;
  }

  bool validarNome(String novoNome) {
    return novoNome == nome;
  }
  
}

