import 'package:flutter/material.dart';
import 'package:recipe_cloud_app/core/services/auth_service.dart';
import 'package:recipe_cloud_app/core/services/recipe_service.dart';
import 'package:recipe_cloud_app/features/auth/presentation/pages/login_page.dart';
import 'package:recipe_cloud_app/features/auth/presentation/pages/signup_page.dart';
import 'package:recipe_cloud_app/features/recipes/presentation/pages/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatefulWidget {
  final AuthService authService;
  final RecipeService recipeService;

  const AuthGate({
    super.key,
    required this.authService,
    required this.recipeService,
  });

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _showLoginPage = true;

  void _toggleAuthPages() {
    setState(() {
      _showLoginPage = !_showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: widget.authService.authStateChanges,
      builder: (context, snapshot) {
        // This check is important to handle the initial state before the stream emits.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final session = snapshot.data?.session;

        if (session != null && session.user != null) {
          return HomePage(
            recipeService: widget.recipeService,
            authService: widget.authService,
          );
        } else {
          if (_showLoginPage) {
            return LoginPage(
              authService: widget.authService,
              onSignedIn: () {
                /* StreamBuilder will rebuild */
              },
              onNavigateToSignUp: _toggleAuthPages,
            );
          } else {
            return SignUpPage(
              authService: widget.authService,
              onSignedIn: () {
                /* StreamBuilder will rebuild */
              },
              onNavigateToLogin: _toggleAuthPages,
            );
          }
        }
      },
    );
  }
}
