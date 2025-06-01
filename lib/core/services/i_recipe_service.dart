abstract class IRecipeService {
  Future<List<Map<String, dynamic>>> fetchRecipes();
  // Add other recipe-related methods here, e.g., addRecipe, deleteRecipe
}
