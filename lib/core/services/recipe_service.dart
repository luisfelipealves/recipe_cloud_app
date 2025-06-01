import 'package:recipe_cloud_app/core/services/i_recipe_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecipeService implements IRecipeService {
  final SupabaseClient _client;

  RecipeService(this._client);

  @override
  Future<List<Map<String, dynamic>>> fetchRecipes() async {
    try {
      final response = await _client.from('recipes').select();
      // Supabase < 2.0 returns List<dynamic>, Supabase >= 2.0 returns List<Map<String, dynamic>> directly
      // If you are on Supabase < 2.0, you might need:
      // return List<Map<String, dynamic>>.from(response as List);
      return response;
    } catch (e) {
      // Handle error appropriately, maybe throw a custom domain exception
      throw Exception('Failed to fetch recipes: $e');
    }
  }
}
