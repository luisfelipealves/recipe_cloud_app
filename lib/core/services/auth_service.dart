import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:recipe_cloud_app/core/errors/auth_exception_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client;

  AuthService(this._client);

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  User? get currentUser => _client.auth.currentUser;

  // Consider returning a custom result object or enum for more complex scenarios
  Future<String?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse res = await _client.auth.signUp(
        email: email,
        password: password,
      );
      if (res.user == null) {
        // This case might indicate an unexpected issue with Supabase response
        throw Exception(
          'Sign up failed: No user object returned from Supabase.',
        );
      }
      debugPrint('Sign up successful for user: ${res.user!.id}');

      // Check if email confirmation is pending
      if (res.session == null &&
          res.user != null &&
          res.user!.emailConfirmedAt == null) {
        return 'Please check your email to confirm your account.';
      }
      // If session is created, sign-up was successful and user is likely auto-logged in
      return null; // Indicates success or auto-login
    } on AuthException catch (e) {
      debugPrint('Supabase AuthException on sign up: ${e.message}');
      throw Exception(AuthExceptionHandler.handleException(e, isSignUp: true));
    } catch (e) {
      debugPrint('Generic exception on sign up: $e');
      throw Exception(AuthExceptionHandler.handleException(e));
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
      throw Exception(AuthExceptionHandler.handleException(e));
    }
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<void> signInWithGoogle() async {
    try {
      await _client.auth.signInWithOAuth(OAuthProvider.google);
    } on AuthException catch (e) {
      debugPrint('Supabase AuthException on Google sign in: ${e.message}');
      throw Exception(AuthExceptionHandler.handleException(e));
    } catch (e) {
      debugPrint('Generic exception on Google sign in: $e');
      throw Exception(AuthExceptionHandler.handleException(e));
    }
  }
}
