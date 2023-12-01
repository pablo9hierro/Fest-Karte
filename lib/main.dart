import 'package:flutter/material.dart';
import 'package:sem_23/models/usuario_models.dart';
import 'package:logger/logger.dart';
var logger = Logger();

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Usuario usuario = Usuario(); // Crie uma instância de Usuario

    return MaterialApp(
      title: 'Meu App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      routes: {
        '/': (context) =>  _HomeScreen(),
        '/tela_um': (context) => _TelaUm(usuario: usuario), // Corrija a rota // Passe o usuário para _TelaUm
        'loja_ingressos': (context) => _LojaIngressoClasse(usuario: usuario), // Passe o usuário para _LojaIngressoClasse
      },
    );
  }
}





class _HomeScreen extends StatelessWidget {

  
 const _HomeScreen({Key? key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha App'),
      ),
      body: Center(
        child: 
        ElevatedButton(
      onPressed: () {
     Navigator.pushNamed(
              context,
              '/tela_um');
          },
  child: const Text('Ir para Tela Um'),
),
      ),
    );
  }
}

class _TelaUm extends StatelessWidget {
  final Usuario usuario; // Declare a variável aqui

  // Construtor que recebe o usuário
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
          ],
        ),
      ),
    );
  }
}



class _LojaIngressoClasse extends StatelessWidget {
  final Usuario usuario; // Adicione o usuário como propriedade

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
        itemCount: usuario.tipoUsuario == TipoUsuario.cliente
            ? usuario.favoritos.length // Substitua por seus dados reais
            : 0,
        itemBuilder: (BuildContext context, int index) {
          Ingresso ingresso = usuario.favoritos[index]; // Substitua por seus dados reais

          return GestureDetector(
            // onTap: () {
            //   if (usuario.tipoUsuario == TipoUsuario.cliente) {
            //     // Se o usuário for um cliente, navegue para a página TelaComprar
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => _TelaComprar(ingresso: ingresso),
            //       ),
            //     );
            //   }
            // },
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
                    ingresso.imagem,
                    height: 100.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    ingresso.descricao,
                    style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  Text('R\$ ${ingresso.valorIngresso.toString()}'),
                  // Adicione o Checkbox
                  if (usuario.tipoUsuario == TipoUsuario.cliente)
                    Checkbox(
                      value: usuario.favoritos.contains(ingresso),
                      onChanged: (value) {
                        // Lógica para adicionar/remover dos favoritos do cliente
                        usuario.marcarDesmarcarFavorito(ingresso, value);
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



// class _TelaUsuario extends StatelessWidget {
//   final Usuario usuario;

//   const _TelaUsuario({required this.usuario});

//   @override
//   Widget build(BuildContext context) {
//     List<Ingresso> ingressosComprados = usuario.getIngressosComprados();

//     // Agora você pode usar a lista 'ingressosComprados' para renderizar a interface do usuário
//     // e permitir que o usuário clique em cada ingresso.
//     // Exemplo: use um ListView.builder para criar um botão para cada ingresso.

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Ingressos Comprados'),
//       ),
//       body: ListView.builder(
//         itemCount: ingressosComprados.length,
//         itemBuilder: (BuildContext context, int index) {
//           Ingresso ingresso = ingressosComprados[index];
//           return ListTile(
//             title: Text(ingresso.descricao),
//             // Adicione aqui a lógica para navegar para os detalhes do ingresso
//             onTap: () {
//               // Exemplo: navegar para a tela de detalhes do ingresso
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => DetalhesIngresso(ingresso: ingresso),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
