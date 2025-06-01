import 'package:flutter/material.dart';
import 'package:recipe_cloud_app/core/services/recipe_service.dart';
import 'package:recipe_cloud_app/core/theme/app_theme.dart';
import 'package:recipe_cloud_app/features/recipes/presentation/pages/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Cria a instância do RecipeService aqui ou usa um Service Locator/DI
    final recipeService = RecipeService(Supabase.instance.client);

    return MaterialApp(
      title: 'Recipe Cloud', // O título do seu app
      theme: AppTheme.lightTheme, // Define o tema claro como padrão
      darkTheme: AppTheme.darkTheme, // Define o tema escuro
      themeMode:
          ThemeMode.system, // Opcional: usa o tema do sistema (light/dark)
      // ou ThemeMode.light / ThemeMode.dark para forçar um tema
      home: HomePage(recipeService: recipeService),
    );
  }
}
