import 'package:flutter/material.dart';
import 'package:recipe_cloud_app/core/services/auth_service.dart';
import 'package:recipe_cloud_app/features/auth/presentation/viewmodels/login_viewmodel.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // For SupabaseClient, if needed for DI

class LoginPage extends StatefulWidget {
  final AuthService authService;
  final VoidCallback onSignedIn;
  final VoidCallback onNavigateToSignUp;

  const LoginPage({
    super.key,
    required this.authService,
    required this.onSignedIn,
    required this.onNavigateToSignUp,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final LoginViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    // In a real app with DI (e.g., Provider), ViewModel would be obtained from context.
    // For this example, we instantiate it directly.
    // Ensure Supabase.instance.client is initialized before this page is built.
    _viewModel = LoginViewModel(
      widget.authService,
    ); // AuthService implements IAuthService
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _emailController.addListener(_viewModel.clearErrorMessage);
    _passwordController.addListener(_viewModel.clearErrorMessage);

    _viewModel.addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    // Rebuild the widget if isLoading or errorMessage changes
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      final success = await _viewModel.signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (success && mounted) {
        widget.onSignedIn();
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
                        'Welcome Back!', // More engaging title
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
                          hintText: 'Enter your password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                        obscureText: true,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Enter password'
                            : null,
                      ),
                      const SizedBox(height: 30),
                      if (_viewModel.isLoading)
                        const Center(child: CircularProgressIndicator())
                      else
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                12.0,
                              ), // Example: Use a brand color
                            ),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            backgroundColor:
                                Colors.orange, // Example: Use a brand color
                          ),
                          onPressed: _signIn,
                          child: const Text('Login'),
                        ),
                      if (_viewModel.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 20.0,
                            bottom: 10.0,
                          ),
                          child: Text(
                            _viewModel.errorMessage!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: widget.onNavigateToSignUp,
                        child: RichText(
                          text: TextSpan(
                            text: 'Don\'t have an account? ',
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.color,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Sign Up',
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
    _viewModel.removeListener(_onViewModelChanged);
    _emailController.removeListener(_viewModel.clearErrorMessage);
    _passwordController.removeListener(_viewModel.clearErrorMessage);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
