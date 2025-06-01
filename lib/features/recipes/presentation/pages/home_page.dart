import 'package:flutter/material.dart';
import 'package:recipe_cloud_app/core/services/auth_service.dart';
import 'package:recipe_cloud_app/core/services/recipe_service.dart';
import 'package:recipe_cloud_app/features/recipes/presentation/viewmodels/home_viewmodel.dart';

// Assuming RecipeService and AuthService are provided via DI or constructor
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
  late final HomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    // In a real app with DI, ViewModel would be obtained from context.
    _viewModel = HomeViewModel(widget.recipeService, widget.authService);
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.fetchRecipes();
  }

  void _onViewModelChanged() {
    // Rebuild the widget if state changes
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // final viewModel = Provider.of<HomeViewModel>(context); // Example with Provider
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
            onPressed: () async => await _viewModel.signOut(),
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (_viewModel.state) {
      case HomeState.loading:
      case HomeState.initial:
        return const Center(child: CircularProgressIndicator());
      case HomeState.error:
        return Center(
          child: Text(_viewModel.errorMessage ?? 'An unknown error occurred.'),
        );
      case HomeState.loaded:
        if (_viewModel.recipes.isEmpty) {
          return const Center(child: Text('No recipes found.'));
        }
        final recipes = _viewModel.recipes;
        return ListView.builder(
          itemCount: recipes.length,
          itemBuilder: ((context, index) {
            final recipe = recipes[index];
            return ListTile(title: Text(recipe['name'] ?? 'Untitled Recipe'));
          }),
        );
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    // If ViewModel had any resources to dispose, call them here.
    // _viewModel.dispose(); // If you add a dispose method to ViewModel
    super.dispose();
  }
}
