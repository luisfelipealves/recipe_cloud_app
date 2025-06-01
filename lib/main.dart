import 'package:flutter/material.dart';
import 'package:recipe_cloud_app/core/config/supabase_initializer.dart';
import 'package:recipe_cloud_app/presentation/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final bool supabaseInitialized = await SupabaseInitializer.initialize();

  if (!supabaseInitialized) {
    return;
  }
  runApp(const MyApp());
}
