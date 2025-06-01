import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client;

  AuthService(this._client);

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  User? get currentUser => _client.auth.currentUser;

  Future<void> signUp({required String email, required String password}) async {
    try {
      final AuthResponse res = await _client.auth.signUp(
        email: email,
        password: password,
      );
      if (res.user == null) {
        throw Exception('Sign up failed: No user returned.');
      }
      debugPrint('Sign up successful for user: ${res.user!.id}');
    } on AuthException catch (e) {
      debugPrint('Supabase AuthException on sign up: ${e.message}');
      throw Exception('Sign up failed: ${e.message}');
    } catch (e) {
      debugPrint('Generic exception on sign up: $e');
      throw Exception('An unexpected error occurred during sign up.');
    }
  }

  Future<void> signInWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
    } on AuthException catch (e) {
      debugPrint('Supabase AuthException on sign in: ${e.message}');
      throw Exception('Sign in failed: ${e.message}');
    }
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
