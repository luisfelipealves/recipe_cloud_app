import 'package:flutter/material.dart';
import 'package:recipe_cloud_app/core/services/auth_service.dart';
import 'package:recipe_cloud_app/core/services/recipe_service.dart';
import 'package:recipe_cloud_app/core/theme/app_theme.dart';
import 'package:recipe_cloud_app/features/auth/presentation/pages/auth_gate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final supabaseClient = Supabase.instance.client;
    final authService = AuthService(supabaseClient);
    final recipeService = RecipeService(supabaseClient);

    return MaterialApp(
      title: 'Recipe Cloud',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: AuthGate(authService: authService, recipeService: recipeService),
    );
  }
}
