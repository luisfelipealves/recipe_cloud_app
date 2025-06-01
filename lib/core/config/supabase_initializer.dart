import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseInitializer {
  static Future<bool> initialize() async {
    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      debugPrint('AVISO: Não foi possível carregar o arquivo .env: $e.');
      // Dependendo da criticidade, você pode querer retornar false aqui
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
      return false; // Indica falha na inicialização
    }

    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
    debugPrint('Supabase inicializado com sucesso.');
    return true;
  }
}
