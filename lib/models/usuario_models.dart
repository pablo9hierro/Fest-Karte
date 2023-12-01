import 'package:logger/logger.dart';
var logger = Logger();
enum TipoUsuario { cliente, fornecedor }

class Usuario {
  final String? id; // id é uma String no MongoDB
  final TipoUsuario? tipoUsuario;
  double saldo;
  final String nome;
  final String email;
  final List<Ingresso> ingressosComprados;
  final List<String> convites;
  final List<Ingresso> favoritos;

  Usuario({
    this.id,
    this.tipoUsuario,
    this.saldo = 0.0,
    this.nome = '',
    this.email = '',
    List<Ingresso>? ingressosComprados,
    this.convites = const [],
    List<Ingresso>? favoritos,
  })  : ingressosComprados = ingressosComprados ?? [],
        favoritos = favoritos ?? [];

  // Método para cadastrar um novo ingresso
  void cadastrarIngresso(Ingresso novoIngresso) {
    if (tipoUsuario == TipoUsuario.fornecedor) {
      // Lógica para fornecedor cadastrar um novo ingresso
    } else {
      logger.i("Apenas fornecedores podem cadastrar ingressos.");
    }
  }

  // Método para comprar um ingresso
  void comprarIngresso(Ingresso ingresso) {
    if (tipoUsuario == TipoUsuario.cliente && saldo >= ingresso.valorIngresso) {
      saldo -= ingresso.valorIngresso;
      ingressosComprados.add(ingresso);
      logger.i("Ingresso comprado com sucesso!");
    } else {
      logger.e("Usuário não é cliente ou não tem saldo suficiente.");
    }
  }

        // como usar 
        // fornecedor.cadastrarIngresso(novoIngresso);
        // cliente.comprarIngresso(novoIngresso);


      //retorna lista de ingressos comprados
   List<Ingresso> getIngressosComprados() {
    if (tipoUsuario == TipoUsuario.cliente) {
      return List<Ingresso>.from(ingressosComprados);
    } else {
      // Se o usuário não for um cliente, retorna uma lista vazia
      return [];
    }
  }

  // Método para marcar ou desmarcar um ingresso como favorito
  void marcarDesmarcarFavorito(Ingresso ingresso, bool? value) {
    if (tipoUsuario == TipoUsuario.cliente) {
      if (value == true) {
        favoritos.add(ingresso);
      } else {
        favoritos.remove(ingresso);
      }
    } else {
      logger.i("adicionado aos favoritos.");
    }
  }

  // Método para retornar lista de favoritos marcados checkbox
  List<Ingresso> getListaFavoritos() {
    if (tipoUsuario == TipoUsuario.cliente) {
      return List<Ingresso>.from(favoritos);
    } else {
      // Se o usuário não for um cliente, retorna uma lista vazia
      return [];
    }
  }

}

class Ingresso {
  final double valorIngresso;
  final String imagem;
  final String descricao;
  final String dataEvento;
  final String dataPostagem;
  final String localEvento;
  final String qrCode;

  Ingresso({
    required this.valorIngresso,
    required this.imagem,
    required this.descricao,
    required this.dataEvento,
    required this.dataPostagem,
    required this.localEvento,
    required this.qrCode,
  });

  Ingresso.fromMap(Map<String, dynamic> map)
      : valorIngresso = map['valorIngresso'],
        imagem = map['imagem'],
        descricao = map['descricao'],
        dataEvento = map['dataEvento'],
        dataPostagem = map['dataPostagem'],
        localEvento = map['localEvento'],
        qrCode = map['qrCode'];

        
}



