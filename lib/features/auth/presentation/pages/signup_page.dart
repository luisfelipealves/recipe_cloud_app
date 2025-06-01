import 'package:flutter/material.dart';
import 'package:recipe_cloud_app/core/services/auth_service.dart';

class SignUpPage extends StatefulWidget {
  final AuthService authService;
  final VoidCallback onSignedIn;
  final VoidCallback onNavigateToLogin;

  const SignUpPage({
    super.key,
    required this.authService,
    required this.onSignedIn,
    required this.onNavigateToLogin,
  });

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_clearErrorMessage);
    _passwordController.addListener(_clearErrorMessage);
  }

  void _clearErrorMessage() {
    if (_errorMessage != null && mounted) {
      setState(() {
        _errorMessage = null;
      });
    }
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long.';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain an uppercase letter.';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain a special character.';
    }
    return null;
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      try {
        final String? signUpMessage = await widget.authService.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (mounted) {
          if (signUpMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(signUpMessage)));
          } else if (widget.authService.currentUser != null) {
            widget.onSignedIn();
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _errorMessage = e.toString().replaceFirst('Exception: ', '');
          });
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(
                  Icons.restaurant_menu, // Ícone de chapéu de chef (ou similar)
                  size: 60,
                  // color: Theme.of(context).primaryColor, // Opcional: usar cor do tema
                ),
                const SizedBox(height: 16),
                Text(
                  'Recipe Cloud',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text('Sign Up', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 32), // Espaço antes do formulário
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email address',
                    hintStyle: TextStyle(
                      fontSize: 13.0,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter email' : null,
                  keyboardType: TextInputType.emailAddress,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Min. 8 chars, 1 uppercase, 1 special char.',
                    hintStyle: TextStyle(
                      fontSize: 13.0, // Smaller font size
                      color: Theme.of(
                        context,
                      ).hintColor, // Same color as the unfocused label
                    ),
                  ),
                  obscureText: true,
                  validator: _validatePassword,
                ),
                const SizedBox(height: 20),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _signUp,
                    child: const Text('Sign Up'),
                  ),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                TextButton(
                  onPressed: widget.onNavigateToLogin,
                  child: const Text('Already have an account? Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
