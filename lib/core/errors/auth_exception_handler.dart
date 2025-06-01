import 'package:supabase_flutter/supabase_flutter.dart';

class AuthExceptionHandler {
  static String handleException(dynamic e, {bool isSignUp = false}) {
    if (e is AuthException) {
      return _mapAuthExceptionMessage(e, isSignUp: isSignUp);
    } else if (e is Exception) {
      // For other general exceptions caught by the AuthService
      return e.toString().replaceFirst('Exception: ', '');
    }
    return 'An unexpected error occurred. Please try again.';
  }

  static String _mapAuthExceptionMessage(
    AuthException e, {
    bool isSignUp = false,
  }) {
    final message = e.message.toLowerCase();
    if (message.contains('invalid login credentials')) {
      return 'Invalid email or password. Please try again.';
    } else if (message.contains('user already registered') && isSignUp) {
      return 'This email is already registered. Please try logging in.';
    } else if (message.contains('email rate limit exceeded')) {
      return 'Too many attempts. Please try again later.';
    } else if (message.contains('email not confirmed')) {
      return 'Please verify your email before logging in. Check your inbox for a confirmation link.';
    }
    return e.message; // Fallback to the original Supabase message
  }
}
