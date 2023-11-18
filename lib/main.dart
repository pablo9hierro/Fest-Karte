import 'package:flutter/material.dart';
import 'package:sem_23/models/usuario_models.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
      routes: {
        // Correção: Remova 'const' ao criar a instância CadastroScreen
        'Cadastro': (context) => _CadastroScreen(usuario: Usuario(avatarUrl: "https://imgs.search.brave.com/mKHvNlCdLPoHI5tdXTPvb9VTNoJwg3qL7TiIIBNUD1g/rs:fit:500:0:0/g:ce/aHR0cHM6Ly9pbWcu/ZnJlZXBpay5jb20v/dmV0b3Jlcy1wcmVt/aXVtL2ZhbnRhc3Rp/Y28tZS1wb2Rlcm9z/by12ZXRvci1kZS1h/cnRlLWRvLWVtYmxl/bWEtdmlraW5nXzcy/Mjk2NC01Mi5qcGc_/c2l6ZT02MjYmZXh0/PWpwZw", id: '1',nome: "pablo",email: "pablo@gmail.com")), // Passe uma instância válida de Usuario aqui
        'Login':(context) => _LoginTela(usuario: Usuario(avatarUrl: "https://imgs.search.brave.com/mKHvNlCdLPoHI5tdXTPvb9VTNoJwg3qL7TiIIBNUD1g/rs:fit:500:0:0/g:ce/aHR0cHM6Ly9pbWcu/ZnJlZXBpay5jb20v/dmV0b3Jlcy1wcmVt/aXVtL2ZhbnRhc3Rp/Y28tZS1wb2Rlcm9z/by12ZXRvci1kZS1h/cnRlLWRvLWVtYmxl/bWEtdmlraW5nXzcy/Mjk2NC01Mi5qcGc_/c2l6ZT02MjYmZXh0/PWpwZw", id: '1',nome: "pablo",email: "pablo@gmail.com"),)
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha App'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, 'Cadastro');
          },
          child: const Text('Ir para Cadastro'),
        ),
      ),
    );
  }
}

class _CadastroScreen extends StatefulWidget {
  final Usuario usuario;

  const _CadastroScreen({Key? key, required this.usuario}) : super(key: key);

  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<_CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _novoEmail;
  String? _novoNome;
  String? _novaAvatarUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tela de Cadastro'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'insira seu email'),
              onChanged: (novoEmail) {
                setState(() {
                  _novoEmail = novoEmail;
                });
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'insira seu nome de usuário'),
              onChanged: (novoNome) {
                setState(() {
                  _novoNome = novoNome;
                });
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'cole uma url para ser sua imagem de avatar'),
              onChanged: (novaAvatarUrl) {
                setState(() {
                  _novaAvatarUrl = novaAvatarUrl;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Lógica para enviar os dados do formulário para o objeto usuario
                  widget.usuario.receberEmail(_novoEmail!);
                  widget.usuario.receberNome(_novoNome!);
                  widget.usuario.receberAvatarUrl(_novaAvatarUrl!);

                  // Navegar de volta para a tela anterior
                  Navigator.pop(context);
                  //lógica para seguir para tela de login
                  Navigator.pushNamed(context, 'Login');
                }
              },
              child: const Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginTela extends StatelessWidget {
  final Usuario usuario;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  _LoginTela({required this.usuario, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha App'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Insira seu nome de usuário'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira seu nome de usuário';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Insira seu email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira seu email';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final novoNome = _nomeController.text;
                  final novoEmail = _emailController.text;

                  if (usuario.validarEmail(novoEmail) && usuario.validarNome(novoNome)) {
                    // Os dados do formulário são válidos e correspondem aos dados armazenados no objeto usuario
                    // Faça o que for necessário aqui
                  } else {
                    // Exibir uma mensagem de erro ou tomar outra ação se os dados não forem válidos
                  }
                }
              },
              child: const Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}
