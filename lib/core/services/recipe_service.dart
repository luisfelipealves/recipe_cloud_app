import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecipeService {
  final SupabaseClient _client;

  RecipeService(this._client);

  Future<List<Map<String, dynamic>>> fetchRecipes() async {
    try {
      final data = await _client.from('recipes').select();
      return data;
    } on PostgrestException catch (error) {
      debugPrint('Supabase error fetching recipes: ${error.message}');
      throw Exception('Failed to fetch recipes: ${error.message}');
    } catch (e) {
      debugPrint('Generic exception fetching recipes: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
