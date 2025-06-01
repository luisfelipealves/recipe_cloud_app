import 'package:supabase_flutter/supabase_flutter.dart';

abstract class IAuthService {
  Stream<AuthState> get authStateChanges;
  User? get currentUser;

  Future<String?> signUp({required String email, required String password});

  Future<void> signInWithPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();
}
