import 'package:logger/logger.dart';
import 'package:postgres/postgres.dart';


var logger = Logger();
late PostgreSQLConnection _connection;

//classe para representar o postgrees pra minha aplicação
class Database {
  //abrir banco de dados
  static Future<void> openConnection() async {
    _connection = PostgreSQLConnection('localhost', 5432, 'pablo_banco', username: 'pablo', password: '045');
    await _connection.open();
  }
  //fechar banco de dados
    Future<void> close() async {
    await _connection.close();
  }


   // adicionar um novo ingresso ao banco de dados
  static Future<void> adicionarIngresso(Ingresso ingresso, String usuarioId) async {
    await _connection.open();
    await _connection.query(
      'INSERT INTO ingressos (id, valorIngresso, descricao, dataEvento, localEvento, usuario_id) '
      'VALUES (@id, @valorIngresso, @descricao, @dataEvento, @localEvento, @usuarioId)',
      substitutionValues: {
        'id': ingresso.id,
        'valorIngresso': ingresso.valorIngresso,
        'descricao': ingresso.descricao,
        'dataEvento': ingresso.dataEvento,
        'localEvento': ingresso.localEvento,
        'usuarioId': usuarioId,
      },
    );
    await _connection.close();
  }


   // método para atualizar a lista de favoritos no banco de dados
  static Future<void> atualizarFavoritos(List<String> favoritos, String usuarioId) async {
    await _connection.open();
    await _connection.query('UPDATE usuarios SET favoritos = @favoritos WHERE id = @id', substitutionValues: {
      'favoritos': favoritos,
      'id': usuarioId,
    });
    await _connection.close();
  }


  
}




enum TipoUsuario { cliente, fornecedor }

class Usuario {
  final String? id; 
  final TipoUsuario? tipoUsuario;
  double saldo;
  final String nome;
  final String email;
  final List<Ingresso> ingressosComprados;
  final List<String> convites;
  final List<Ingresso> favoritos;
  final List<Ingresso> ingressosVenda;

  Usuario({
    this.id,
    this.tipoUsuario,
    this.saldo = 0.0,
    this.nome = '',
    this.email = '',
    List<Ingresso>? ingressosComprados,
    this.convites = const [],
    List<Ingresso>? favoritos,
     List<Ingresso>? ingressosVenda,
  })  : ingressosComprados = ingressosComprados ?? [],
        favoritos = favoritos ?? [],
        ingressosVenda = ingressosVenda ?? [];




  // método para comprar um ingresso
Future<void> comprarIngresso(Ingresso ingresso) async {
  if (tipoUsuario == TipoUsuario.cliente && saldo >= ingresso.valorIngresso!) {
    saldo -= ingresso.valorIngresso!.toDouble(); // convertido para double
    ingressosComprados.add(ingresso);

    await _connection.open();
    await _connection.query(
      'UPDATE usuarios SET saldo = @novoSaldo, ingressos_comprados = @novosIngressos WHERE id = @id',
      substitutionValues: {
        'novoSaldo': saldo,
        'novosIngressos': ingressosComprados.map((i) => i.id).toList(),
        'id': id,
      },
    );
    await _connection.close();

    logger.i("Ingresso comprado com sucesso!");
  } else {
    logger.e("Usuário não é cliente ou não tem saldo suficiente.");
  }
}


        // como usar 
        // fornecedor.cadastrarIngresso(novoIngresso);
        // cliente.comprarIngresso(novoIngresso);


      //retorna lista de ingressos comprados
Future<List<Ingresso>> getIngressosComprados() async {
  if (tipoUsuario == TipoUsuario.cliente) {
    // Lógica para obter os ingressos comprados do banco de dados
    await _connection.open();
    final results = await _connection.query('SELECT * FROM ingressos WHERE usuario_id = @id', substitutionValues: {'id': id});
    await _connection.close();

    // mapear os resultados para objetos Ingresso
    List<Ingresso> ingressos = [];
    for (final row in results) {
      ingressos.add(Ingresso.fromMap(row.toColumnMap()));
    }
    return ingressos;
  } else {
    // se o usuário não for um cliente, retorna uma lista vazia
    return [];
  }
}

 // método para marcar ou desmarcar um ingresso como favorito
  Future<void> marcarDesmarcarFavorito(Ingresso ingresso, bool value) async {
    if (tipoUsuario == TipoUsuario.cliente) {
      if (value) {
        favoritos.add(ingresso);
      } else {
        favoritos.remove(ingresso);
      }

      // atualizar a lista de favoritos no banco de dados
      await Database.atualizarFavoritos(favoritos.map((i) => i.id).toList(), id!);
    } else {
      logger.i("Apenas usuários clientes podem marcar ingressos como favoritos.");
    }
  }


  // método para retornar lista de favoritos marcados checkbox
 Future<List<Ingresso>> getListaFavoritos() async {
  if (tipoUsuario == TipoUsuario.cliente) {
    //obter a lista de favoritos do banco de dados
    await _connection.open();
    final results = await _connection.query('SELECT * FROM favoritos WHERE usuario_id = @id', substitutionValues: {'id': id});
    await _connection.close();

    // mapear os resultados para objetos Ingresso
    List<Ingresso> favoritos = results.map((row) => Ingresso.fromMap(row.toColumnMap())).toList();
    return favoritos;
  } else {
    // Se o usuário não for um cliente, retorna uma lista vazia
    return [];
  }
}




    // adicionar um novo ingresso à lista de ingressos para venda
  //pra ser renderizado no catálogo de vendas
        Future<void> adicionarIngressoVenda(Ingresso ingresso) async {
          if (tipoUsuario == TipoUsuario.fornecedor) {
            ingressosVenda.add(ingresso);
            await Database.adicionarIngresso(ingresso, id!);
            logger.i("Ingresso adicionado à lista de venda.");
          } else {
            logger.e("Apenas usuários fornecedores podem adicionar ingressos à lista de venda.");
          }
        }

}



class Ingresso {
  final String id;
  final double? valorIngresso;
  final String? imagem;
  final String? descricao;
  final String? dataEvento;
  final String? dataPostagem;
  final String? localEvento;
  final String? qrCode;

  Ingresso({
    required this.id,
    this.valorIngresso,
    this.imagem,
    this.descricao,
    this.dataEvento,
    this.dataPostagem,
    this.localEvento,
    this.qrCode,
  });

  factory Ingresso.fromMap(Map<String, dynamic> map) {
    return Ingresso(
      id: map['id'],
      valorIngresso: map['valorIngresso'],
      imagem: map['imagem'],
      descricao: map['descricao'],
      dataEvento: map['dataEvento'],
      dataPostagem: map['dataPostagem'],
      localEvento: map['localEvento'],
      qrCode: map['qrCode'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'valorIngresso': valorIngresso,
      'imagem': imagem,
      'descricao': descricao,
      'dataEvento': dataEvento,
      'dataPostagem': dataPostagem,
      'localEvento': localEvento,
      'qrCode': qrCode,
    };
  }
}

