import 'package:flutter/foundation.dart';
import 'package:recipe_cloud_app/core/services/i_auth_service.dart';
import 'package:recipe_cloud_app/core/errors/auth_exception_handler.dart';

enum SignUpStatus {
  initial,
  loading,
  success,
  failure,
  emailConfirmationRequired,
}

class SignUpViewModel extends ChangeNotifier {
  final IAuthService _authService;

  SignUpViewModel(this._authService);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _successMessage;
  String? get successMessage => _successMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    _successMessage = null; // Clear success message on error
    notifyListeners();
  }

  void _setSuccessMessage(String? message) {
    _successMessage = message;
    _errorMessage = null; // Clear error message on success
    notifyListeners();
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  Future<SignUpStatus> signUp(String email, String password) async {
    _setLoading(true);
    clearMessages();
    try {
      final String? signUpServiceMessage = await _authService.signUp(
        email: email,
        password: password,
      );
      _setLoading(false);
      _setSuccessMessage(
        signUpServiceMessage,
      ); // This might be the "check your email" message
      return signUpServiceMessage != null
          ? SignUpStatus.emailConfirmationRequired
          : SignUpStatus.success;
    } catch (e) {
      _setErrorMessage(AuthExceptionHandler.handleException(e, isSignUp: true));
      _setLoading(false);
      return SignUpStatus.failure;
    }
  }
}
