import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrarse"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Crea una cuenta",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            
            // Botones de redes sociales
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialButton('assets/google.svg', () {
                  // Lógica para registro con Google
                }),
                SizedBox(width: 16),
                _buildSocialButton('assets/facebook.svg', () {
                  // Lógica para registro con Facebook
                }),
                SizedBox(width: 16),
                _buildSocialButton('assets/apple.svg', () {
                  // Lógica para registro con Apple
                }),
              ],
            ),
            SizedBox(height: 24),
            
            // Texto alternativo para crear cuenta con formulario
            Text(
              "O crea una cuenta aquí",
              style: TextStyle(color: AppColors.textPrimary, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup_form');
              },
              child: Text("Crear cuenta"),
            ),
          ],
        ),
      ),
    );
  }

  // Botón de redes sociales con efecto cristal
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
                width: 28,
                height: 28,
                placeholderBuilder: (context) => CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
