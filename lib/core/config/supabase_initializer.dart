import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseInitializer {
  static Future<bool> initialize() async {
    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      debugPrint('WARNING: Could not load .env file: $e.');
    }

    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

    if (supabaseUrl == null ||
        supabaseUrl.isEmpty ||
        supabaseAnonKey == null ||
        supabaseAnonKey.isEmpty) {
      debugPrint(
        'CRITICAL ERROR: SUPABASE_URL or SUPABASE_ANON_KEY not found in .env or are empty.',
      );
      return false;
    }

    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
    debugPrint('Supabase initialized successfully.');
    return true;
  }
}
