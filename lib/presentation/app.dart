import 'package:flutter/material.dart';
import 'package:recipe_cloud_app/core/services/recipe_service.dart';
import 'package:recipe_cloud_app/core/theme/app_theme.dart';
import 'package:recipe_cloud_app/features/recipes/presentation/pages/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final recipeService = RecipeService(Supabase.instance.client);

    return MaterialApp(
      title: 'Recipe Cloud',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: HomePage(recipeService: recipeService),
    );
  }
}
