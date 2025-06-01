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
      debugPrint('Erro do Supabase ao buscar receitas: ${error.message}');
      throw Exception('Falha ao buscar receitas: ${error.message}');
    } catch (e) {
      debugPrint('Exceção genérica ao buscar receitas: $e');
      throw Exception('Ocorreu um erro inesperado: $e');
    }
  }
}
