import 'package:flutter/material.dart';
import 'package:recipe_cloud_app/core/services/auth_service.dart';
import 'package:recipe_cloud_app/core/services/recipe_service.dart';

class HomePage extends StatefulWidget {
  final RecipeService recipeService;
  final AuthService authService;

  const HomePage({
    super.key,
    required this.recipeService,
    required this.authService,
  });

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
      appBar: AppBar(
        elevation: 0, // Remove a sombra
        backgroundColor: Theme.of(
          context,
        ).scaffoldBackgroundColor, // Mesma cor do fundo
        foregroundColor: Colors.orange, // Cor da marca para texto e ícones
        title: const Row(
          mainAxisSize: MainAxisSize.min, // To keep the Row compact
          children: <Widget>[
            Icon(
              Icons.restaurant_menu,
            ), // Ícone consistente com as telas de auth
            SizedBox(width: 8), // Spacing between icon and text
            Text('Recipe Cloud'), // Nome da marca consistente
          ],
        ),
        centerTitle: true, // Centraliza o título (Row)
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async => await widget.authService.signOut(),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureRecipes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading recipes: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No recipes found.'));
          }

          final recipes = snapshot.data!;
          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: ((context, index) {
              final recipe = recipes[index];
              return ListTile(title: Text(recipe['name'] ?? 'Untitled Recipe'));
            }),
          );
        },
      ),
    );
  }
}
