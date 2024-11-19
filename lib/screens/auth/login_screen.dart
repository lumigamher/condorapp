import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:condorapp/theme.dart';
import 'package:condorapp/models/user.dart';
import 'package:condorapp/providers/auth_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Theme(
      data: AppTheme.lightTheme,
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Iniciar Sesión")),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo o título de la app
              const Center(
                child: Text(
                  "Mi Señor Jesús",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Campos de inicio de sesión sin bordes
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Usuario",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Contraseña",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),

              // Botón de inicio de sesión
              ElevatedButton(
                onPressed: () {
                  final user = User(
                    username: _usernameController.text,
                    password: _passwordController.text,
                    email: '',
                    firstName: '',
                    lastName: '',
                  );
                  authProvider.login(user, context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Iniciar Sesión", style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 24),

              // Texto para redes sociales
              Center(
                child: Text(
                  "O inicia sesión con",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textPrimary.withOpacity(0.7),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Botones de redes sociales
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialButton('assets/google.svg', () {
                    // Lógica para iniciar sesión con Google
                  }),
                  const SizedBox(width: 16),
                  _buildSocialButton('assets/facebook.svg', () {
                    // Lógica para iniciar sesión con Facebook
                  }),
                  const SizedBox(width: 16),
                  _buildSocialButton('assets/apple.svg', () {
                    // Lógica para iniciar sesión con Apple
                  }),
                ],
              ),
              const SizedBox(height: 32),

              // Enlace para registrarse
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text(
                    "¿No tienes una cuenta? Regístrate",
                    style: TextStyle(
                      color: AppColors.accent,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String assetName, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: SvgPicture.asset(
                assetName,
                width: 30,
                height: 30,
                placeholderBuilder: (context) => const CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
