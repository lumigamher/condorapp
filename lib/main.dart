import 'package:condorapp/login_screen.dart';
import 'package:condorapp/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:condorapp/colors.dart';
import 'package:condorapp/home_screen.dart';

void main() {
  runApp(const CondorApp());
}

class CondorApp extends StatelessWidget {
  const CondorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const BienvenidaScreen(),  // Pantalla de bienvenida
        '/home': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(), // Pantalla de inicio de sesión
        '/register': (context) => RegisterScreen(), // Pantalla de registro
      },
    );
  }
}

class BienvenidaScreen extends StatelessWidget {
  const BienvenidaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.darkBlue, AppColors.lightBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', width: 150, height: 150),
              const SizedBox(height: 20),
              const Text(
                'Condor',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const Text(
                'Tu Guía Espiritual',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white, // Color de fondo blanco
                  iconColor: AppColors.darkBlue, // Color del texto azul oscuro
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Bordes redondeados
                  ),
                ),
                onPressed: () {
                  // Navegación a la pantalla de inicio (HomeScreen)
                  Navigator.pushNamed(context, '/home');
                },
                child: const Text(
                  'Empieza ahora',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
