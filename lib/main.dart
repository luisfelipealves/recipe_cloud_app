import 'package:flutter/material.dart';
import 'package:recipe_cloud_app/core/config/supabase_initializer.dart';
import 'package:recipe_cloud_app/presentation/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final bool supabaseInitialized = await SupabaseInitializer.initialize();

  if (!supabaseInitialized) {
    // Adicione aqui um log ou tratamento de erro mais robusto se necessário.
    // Por exemplo, exibir uma tela de erro persistente.
    return;
  }
  runApp(const MyApp());
}
