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

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter email';
    }
    // Basic email regex: checks for something@something.something
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
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
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain a number.';
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
            // Aguarda o SnackBar ser dispensado
            await ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(signUpMessage))).closed;

            // Se a mensagem indicar confirmação de e-mail, navega para o login
            if (mounted && // Verifica se o widget ainda está montado após o await
                (signUpMessage.toLowerCase().contains('check your email') ||
                    signUpMessage.toLowerCase().contains(
                      'confirm your account',
                    ))) {
              widget.onNavigateToLogin();
            }
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
      appBar: AppBar(
        title: const Text('Sign Up'),
        elevation: 0, // Remove shadow for a flatter look
        backgroundColor: Theme.of(
          context,
        ).scaffoldBackgroundColor, // Blend with scaffold
        foregroundColor: Colors.orange, // Color for title text and icons
        centerTitle: true, // Ensure title is centered
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
            ), // Max width for the form
            child: Padding(
              padding: const EdgeInsets.all(24.0), // Increased padding
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch, // Make button stretch
                    children: <Widget>[
                      const Icon(
                        Icons.restaurant_menu,
                        size: 64, // Slightly larger icon
                        color: Colors
                            .orangeAccent, // Example: Use a brand accent color
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Recipe Cloud',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color:
                                  Colors.orange, // Example: Use a brand color
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Create Your Account', // More engaging title
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email address',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                        validator: _validateEmail,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText:
                              'Min. 8 chars, 1 uppercase, 1 number, 1 special char.',
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          hintStyle: TextStyle(
                            fontSize: 13.0,
                            color: Theme.of(context).hintColor.withOpacity(0.7),
                          ),
                        ),
                        obscureText: true,
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 30),
                      if (_isLoading)
                        const Center(child: CircularProgressIndicator())
                      else
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            backgroundColor:
                                Colors.orange, // Example: Use a brand color
                          ),
                          onPressed: _signUp,
                          child: const Text('Sign Up'),
                        ),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 20.0,
                            bottom: 10.0,
                          ),
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: widget.onNavigateToLogin,
                        child: RichText(
                          text: TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.color,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Login',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ), // Example: Use a brand color
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
    _emailController.removeListener(_clearErrorMessage);
    _passwordController.removeListener(_clearErrorMessage);
    super.dispose();
  }
}
