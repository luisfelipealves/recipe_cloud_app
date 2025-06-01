import 'package:flutter/material.dart';
import 'package:recipe_cloud_app/core/services/recipe_service.dart';
import 'package:recipe_cloud_app/features/recipes/presentation/pages/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Cria a instância do RecipeService aqui ou usa um Service Locator/DI
    final recipeService = RecipeService(Supabase.instance.client);

    return MaterialApp(
      title: 'Recipe Cloud',
      home: HomePage(recipeService: recipeService),
    );
  }
}
