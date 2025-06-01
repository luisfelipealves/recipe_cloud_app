import 'package:flutter/material.dart';
import 'package:recipe_cloud_app/core/services/recipe_service.dart';

class HomePage extends StatefulWidget {
  final RecipeService recipeService;

  const HomePage({super.key, required this.recipeService});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future<List<Map<String, dynamic>>> _futureRecipes;

  @override
  void initState() {
    super.initState();
    _futureRecipes = widget.recipeService.fetchRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Receitas')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureRecipes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar receitas: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma receita encontrada.'));
          }

          final recipes = snapshot.data!;
          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: ((context, index) {
              final recipe = recipes[index];
              // Exemplo: Exibindo o nome da receita. Adapte conforme sua estrutura de dados.
              return ListTile(
                title: Text(
                  recipe['name'] ?? 'Receita sem nome',
                  style: const TextStyle(color: Colors.black),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
