abstract class IRecipeService {
  /// Fetches a list of recipes.
  ///
  /// Returns a [Future] that completes with a list of maps, where each map represents a recipe.
  /// Throws an [Exception] if fetching recipes fails.
  Future<List<Map<String, dynamic>>> fetchRecipes();
  // Add other recipe-related methods here, e.g., addRecipe, deleteRecipe
}
