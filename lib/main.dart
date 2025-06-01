import 'package:flutter/material.dart';
import 'package:recipe_cloud_app/core/config/supabase_initializer.dart';
import 'package:recipe_cloud_app/presentation/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Essencial antes de operações async

  final bool supabaseInitialized = await SupabaseInitializer.initialize();

  if (!supabaseInitialized) {
    debugPrint(
      'Falha ao inicializar o Supabase. O aplicativo não pode continuar.',
    );
    // Aqui você pode querer exibir uma tela de erro para o usuário
    return; // Impede a execução do app
  }
  runApp(const MyApp());
}
