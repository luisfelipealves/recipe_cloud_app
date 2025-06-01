import 'package:supabase_flutter/supabase_flutter.dart';

abstract class IAuthService {
  /// Stream that emits [AuthState] changes, such as sign-in, sign-out, token refresh, etc.
  ///
  /// This can be used to reactively update the UI based on the user's authentication status.
  Stream<AuthState> get authStateChanges;

  /// Gets the currently signed-in [User].
  ///
  /// Returns `null` if no user is currently authenticated.
  User? get currentUser;

  /// Signs up a new user with the provided [email] and [password].
  ///
  /// Returns a [String?] message, which might indicate that email confirmation is required,
  /// or `null` if the sign-up was successful and the user is potentially auto-logged in.
  /// Throws an [Exception] if the sign-up process fails.
  Future<String?> signUp({required String email, required String password});

  /// Signs in an existing user with the provided [email] and [password].
  ///
  /// Throws an [Exception] if the sign-in process fails (e.g., invalid credentials).
  Future<void> signInWithPassword({
    required String email,
    required String password,
  });

  /// Signs out the currently authenticated user.
  ///
  /// Throws an [Exception] if the sign-out process fails.
  Future<void> signOut();
}
