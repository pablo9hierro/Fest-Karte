import 'package:flutter/material.dart';
import 'package:sem_23/models/usuario_models.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';


var logger = Logger();

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Usuario usuario = Usuario();
    Ingresso ingresso = Ingresso(id: '1'); 
    return MaterialApp(
      title: 'Meu App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      routes: {

        '/': (context) => _TelaUm(usuario: usuario), //
        'loja_ingressos': (context) => _LojaIngressoClasse(usuario: usuario),
        'tela_meus_ingressos': (context) => _TelaMeusIngressos(usuario: usuario), 
        'tela_detalhes_ingresso': (context) => _TelaDetalhesIngresso(ingresso: ingresso, usuario: usuario), 
        '/tela_meus_ingressos': (context) => _TelaMeusIngressos(usuario: usuario),
        '/tela_detalhes_ingresso': (context) => _TelaDetalhesIngresso(ingresso: ingresso, usuario: usuario),
         'tela_anunciar_ingresso': (context) => _TelaAnunciarIngresso(usuario: usuario, ingresso: ingresso),
      },
    );
  }
}




class _TelaMeusIngressos extends StatefulWidget {
  final Usuario usuario;

  const _TelaMeusIngressos({required this.usuario});

  @override
  _TelaMeusIngressosState createState() => _TelaMeusIngressosState();
}

class _TelaMeusIngressosState extends State<_TelaMeusIngressos> {
  String _currentState = 'meusingressos';
  Ingresso? _selectedIngresso;

  @override
  Widget build(BuildContext context) {
    switch (_currentState) {
      case 'meusingressos':
        return Scaffold(
          appBar: AppBar(
            title: const Text('Meus Ingressos'),
          ),
          body: ListView.builder(
            itemCount: widget.usuario.ingressosComprados.length,
            itemBuilder: (context, index) {
              Ingresso ingresso = widget.usuario.ingressosComprados[index];

              return ListTile(
                title: Text(ingresso.descricao ?? ''),
                subtitle: Text(ingresso.dataEvento ?? ''),
                onTap: () {
                  setState(() {
                    _selectedIngresso = ingresso;
                    _currentState = 'detalhesdoingresso';
                  });
                },
              );
            },
          ),
        );
      case 'detalhesdoingresso':
        return Scaffold(
          appBar: AppBar(
            title: const Text('Detalhes do Ingresso'),
          ),
          body: Column(
            children: [
              Text('Valor do Ingresso: ${_selectedIngresso?.valorIngresso ?? ''}'),
              Text('Descrição: ${_selectedIngresso?.descricao ?? ''}'),
              Text('Data do Evento: ${_selectedIngresso?.dataEvento ?? ''}'),
              Text('Data da Postagem: ${_selectedIngresso?.dataPostagem ?? ''}'),
              Text('Local do Evento: ${_selectedIngresso?.localEvento ?? ''}'),
              ElevatedButton(
                onPressed: () {
                  if (_selectedIngresso != null &&
                      DateTime.parse(_selectedIngresso!.dataEvento ?? '').isAfter(DateTime.now().add(const Duration(days: 7)))) {
                    setState(() {
                      _currentState = 'vender';
                    });
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Erro'),
                        content: const Text('O prazo para reembolso deste ingresso já acabou.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: const Text('Vender'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentState = 'abrirqrcode';
                  });
                },
                child: const Text('Abrir QR Code'),
              ),
            ],
          ),
        );
      case 'vender':
        return Scaffold(
          appBar: AppBar(
            title: const Text('Vender Ingresso'),
          ),
          body: const Center(
            child: Text('Implementação da venda de ingressos ainda não foi feita.'),
          ),
        );
      case 'abrirqrcode':
        return Scaffold(
          appBar: AppBar(
            title: const Text('QR Code do Ingresso'),
          ),
          body: const Center(
            child: Text('Implementação da geração de QR Code ainda não foi feita.'),
          ),
        );
      default:
        return Container();
    }
  }
}


// página na qual o usuario terá todos os detalhes do ingresso comprado
//além dos métodos abrirQrCode(), venderIngresso(if>=usuario.dataEvento)

class _TelaDetalhesIngresso extends StatelessWidget {
  final Ingresso ingresso;
  final Usuario usuario;

  const _TelaDetalhesIngresso({required this.ingresso, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Ingresso'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            ingresso.imagem ?? '', // Adicionado operador de nulidade para evitar erro se a imagem for nula
            height: 200.0,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ingresso.descricao ?? '', //  operador de nulidade para evitar erro se a descrição for nula
                  style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Text('Data do Evento: ${ingresso.dataEvento ?? ''}'),
                Text('Local do Evento: ${ingresso.localEvento ?? ''}'),
                Text('Valor: R\$ ${ingresso.valorIngresso?.toString() ?? ''}'),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          if (usuario.tipoUsuario == TipoUsuario.cliente)
            ElevatedButton(
              onPressed: () {
                  usuario.comprarIngresso(ingresso);
              },
              child: const Text('Comprar Ingresso'),
            ),
        ],
      ),
    );
  }
}




class _TelaUm extends StatelessWidget {
  
  final Usuario usuario; // declarar a variável usuario

  // construtor que recebe o usuário
  const _TelaUm({Key? key, required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu"),
        backgroundColor: Colors.grey[800],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => _LojaIngressoClasse(usuario: usuario),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(68, 31, 116, 213),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                textStyle: const TextStyle(fontSize: 24),
              ),
              child: const Text(
                "Ir para loja de ingressos",
                style: TextStyle(color: Colors.white),
              ),
            ),

            // botão para retornar lista de ingressos comprados
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => _TelaMeusIngressos(usuario: usuario),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 211, 226, 48)
                ,padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                textStyle: const TextStyle(fontSize: 24),
              ),
              child: const Text(
                "Meus ingressos comprados",
                style: TextStyle(color: Colors.white),
              ),
            ),

            // botão que leva para '_TelaFavoritos'

             ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => _TelaFavoritos(usuario: usuario),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 211, 226, 48)
                ,padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                textStyle: const TextStyle(fontSize: 24),
              ),
              child: const Text(
                "Meus carrinho",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LojaIngressoClasse extends StatelessWidget {
  final Usuario usuario;

  const _LojaIngressoClasse({required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loja de Ingressos'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: usuario.tipoUsuario == TipoUsuario.cliente ? usuario.favoritos.length : 0,
        itemBuilder: (BuildContext context, int index) {
          Ingresso ingresso = usuario.favoritos[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => _TelaDetalhesIngresso(ingresso: ingresso, usuario: usuario),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey[200],
              ),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    ingresso.imagem ?? '', // operador de nulidade para evitar erro se imagem for nula
                    height: 100.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    ingresso.descricao ?? '', // operador de nulidade para evitar erro se descrição for nula
                    style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  Text('R\$ ${ingresso.valorIngresso?.toString() ?? ''}'), 
                  Checkbox(
                    value: usuario.favoritos.contains(ingresso),
                    onChanged: (value) {
                    usuario.marcarDesmarcarFavorito(ingresso, value ?? false);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


// tela retorna a lista usuario.favritos
// também aparece em forma de baner igual em _LojaIngressoClasse, com todos os métodos
// 
class _TelaFavoritos extends StatelessWidget {
  final Usuario usuario;

  const _TelaFavoritos({required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: usuario.favoritos.length,
        itemBuilder: (BuildContext context, int index) {
          Ingresso ingresso = usuario.favoritos[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => _TelaDetalhesIngresso(ingresso: ingresso, usuario: usuario),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey[200],
              ),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(ingresso.imagem ?? ''), // Adicionei o atributo imagem
                  Text('R\$ ${ingresso.valorIngresso.toString()}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}



//tela para adicionar um novo ingresso {fornecedor}

class _TelaAnunciarIngresso extends StatelessWidget {
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController valorIngressoController = TextEditingController();
  final TextEditingController dataEventoController = TextEditingController();
  final TextEditingController localEventoController = TextEditingController();
final Usuario usuario;
final Ingresso ingresso;
   _TelaAnunciarIngresso({required this.usuario, required this.ingresso});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Ingresso'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: descricaoController,
              decoration: const InputDecoration(
                labelText: 'Descrição do Ingresso',
              ),
            ),
            TextField(
              controller: valorIngressoController,
              decoration: const InputDecoration(
                labelText: 'Valor do Ingresso',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: dataEventoController,
              decoration: const InputDecoration(
                labelText: 'Data do Evento',
              ),
            ),
            TextField(
              controller: localEventoController,
              decoration: const InputDecoration(
                labelText: 'Local do Evento',
              ),
            ),
            ElevatedButton(
  onPressed: () async {
    // para lidar com os inputs
    final String descricao = descricaoController.text;
    final double valorIngresso = double.parse(valorIngressoController.text);
    final String dataEvento = dataEventoController.text;
    final String localEvento = localEventoController.text;

    // criar um novo ingresso
    Ingresso novoIngresso = Ingresso(
      id: const Uuid().v4(), // biblioteca uuid para gerar ID único
      valorIngresso: valorIngresso,
      descricao: descricao,
      dataEvento: dataEvento,
      localEvento: localEvento,
    );

    // adicionar o ingresso à lista de venda
    await usuario.adicionarIngressoVenda(novoIngresso);

   
  },
  child: const Text('Salvar'),
),

          ],
        ),
      ),
    );
  }
}
