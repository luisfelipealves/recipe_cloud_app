import 'package:flutter/foundation.dart';
import 'package:recipe_cloud_app/core/services/i_auth_service.dart';
import 'package:recipe_cloud_app/core/services/i_recipe_service.dart';

enum HomeState { initial, loading, loaded, error }

class HomeViewModel extends ChangeNotifier {
  final IRecipeService _recipeService;
  final IAuthService _authService;

  HomeViewModel(this._recipeService, this._authService);

  HomeState _state = HomeState.initial;
  HomeState get state => _state;

  List<Map<String, dynamic>> _recipes = [];
  List<Map<String, dynamic>> get recipes => _recipes;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _setState(HomeState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> fetchRecipes() async {
    _setState(HomeState.loading);
    _errorMessage = null;
    try {
      _recipes = await _recipeService.fetchRecipes();
      _setState(HomeState.loaded);
    } catch (e) {
      _errorMessage = "Failed to load recipes: ${e.toString()}";
      _setState(HomeState.error);
    }
  }

  Future<void> signOut() async {
    // Optionally, you can set a loading state here if sign out is slow
    // _setState(HomeState.loading); // Or a specific 'loggingOut' state
    try {
      await _authService.signOut();
      // State after sign out will be handled by AuthGate/AuthStateChanges stream
      // No need to call notifyListeners() here if UI reacts to authStateChanges
    } catch (e) {
      // Handle sign out error, maybe show a SnackBar
      debugPrint("Error signing out: $e");
      // If you had a loading state, reset it
      // _setState(HomeState.loaded); // Or back to previous state
    }
  }
}
