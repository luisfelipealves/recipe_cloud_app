import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart'; // Para debugPrint

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Essencial antes de operações async

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('AVISO: Não foi possível carregar o arquivo .env: $e.');
    // Considere o que fazer se o .env não carregar.
    // Para este exemplo, o app pode não funcionar corretamente sem as chaves.
  }

  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

  if (supabaseUrl == null ||
      supabaseUrl.isEmpty ||
      supabaseAnonKey == null ||
      supabaseAnonKey.isEmpty) {
    debugPrint(
      'ERRO CRÍTICO: SUPABASE_URL ou SUPABASE_ANON_KEY não encontradas no .env ou estão vazias.',
    );
    // Impedir a execução do app se a configuração crítica estiver faltando.
    // Você pode querer exibir uma tela de erro ou simplesmente retornar.
    return;
  }

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Recipe Cloud', home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // É melhor inicializar o Future dentro de initState ou didChangeDependencies
  // se ele depender de algo que pode mudar, ou se for uma operação custosa.
  // Para uma simples chamada `select()`, pode ser ok aqui, mas para consistência:
  late final Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = Supabase.instance.client.from('recipes').select();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Receitas')),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma receita encontrada.'));
          }

          final recipes = snapshot.data!;
          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: ((context, index) {
              // final recipe = recipes[index]; // Você usaria isso para exibir dados da receita
              return const ListTile(
                title: Text(
                  'Funcionou!',
                  style: TextStyle(color: Colors.black),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
