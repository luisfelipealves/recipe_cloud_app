import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// Para debugPrint

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Carrega as variáveis de ambiente do arquivo .env
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint(
      'AVISO: Não foi possível carregar o arquivo .env: $e. As variáveis de ambiente podem não estar disponíveis.',
    );
    // Dependendo da criticidade, você pode querer parar a execução aqui.
    // Por exemplo: throw Exception('Falha ao carregar configuração crítica do .env');
  }

  final String? supabaseUrl = dotenv.env['SUPABASE_URL'];
  final String? supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

  if (supabaseUrl == null || supabaseUrl.isEmpty) {
    debugPrint(
      'ERRO CRÍTICO: SUPABASE_URL não está definida no arquivo .env ou está vazia.',
    );
    // Impedir a execução do app se a configuração crítica estiver faltando.
    return; // Ou lance uma exceção para interromper o app
  }

  if (supabaseAnonKey == null || supabaseAnonKey.isEmpty) {
    debugPrint(
      'ERRO CRÍTICO: SUPABASE_ANON_KEY não está definida no arquivo .env ou está vazia.',
    );
    return; // Ou lance uma exceção
  }

  try {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  } catch (e) {
    debugPrint('Erro ao inicializar o Supabase: $e');
    // Impedir a execução do app se o Supabase não puder ser inicializado.
    return; // Ou lance uma exceção
  }

  runApp(const MyApp());
}

// Exemplo de como acessar o cliente Supabase em outros lugares
final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Supabase App',
      home: HomePage(), // Pode ser const se HomePage for const
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Exemplo de como buscar dados
  Future<void> _fetchData() async {
    try {
      // Para supabase_flutter v2.x+, .select() retorna diretamente os dados ou lança uma exceção.
      // O .execute() não é mais usado aqui.
      final List<Map<String, dynamic>> data = await supabase
          .from('recipes')
          .select();

      // Se a linha acima for bem-sucedida, 'data' conterá sua lista de mapas.
      // É uma boa prática verificar se o widget ainda está montado
      // antes de interagir com o estado ou o BuildContext.
      if (mounted) {
        debugPrint('Dados recebidos: $data');
        // Faça algo com os dados, ex: setState(() { _myData = data; });
      }
    } on PostgrestException catch (error) {
      // Trata erros específicos do Supabase (ex: RLS, tabela não encontrada)
      if (mounted) {
        debugPrint('Erro do Supabase ao buscar dados: ${error.message}');
        // Exiba uma mensagem de erro para o usuário, ex: ScaffoldMessenger
      }
    } catch (e) {
      // Trata outros tipos de exceções (ex: problemas de rede)
      if (mounted) {
        debugPrint('Exceção genérica ao buscar dados: $e');
        // Exiba uma mensagem de erro para o usuário
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter com Supabase')),
      body: Center(
        child: ElevatedButton(
          onPressed: _fetchData,
          child: const Text('Buscar Dados da Tabela "sua_tabela"'),
        ),
      ),
    );
  }
}
