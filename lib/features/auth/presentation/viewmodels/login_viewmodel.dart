import 'package:flutter/foundation.dart';
import 'package:recipe_cloud_app/core/services/i_auth_service.dart';
import 'package:recipe_cloud_app/core/errors/auth_exception_handler.dart';

class LoginViewModel extends ChangeNotifier {
  final IAuthService _authService;

  LoginViewModel(this._authService);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearErrorMessage() {
    if (_errorMessage != null) {
      _setErrorMessage(null);
    }
  }

  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      await _authService.signInWithPassword(email: email, password: password);
      _setLoading(false);
      return true;
    } catch (e) {
      // The exception from AuthService should already be processed by AuthExceptionHandler
      // if AuthService re-throws it after processing.
      // If AuthService throws raw Supabase AuthException, then process here.
      _setErrorMessage(AuthExceptionHandler.handleException(e));
      _setLoading(false);
      return false;
    }
  }
}
