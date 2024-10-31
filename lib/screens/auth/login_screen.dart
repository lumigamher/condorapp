import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:condorapp/theme.dart';
import 'package:condorapp/models/user.dart';
import 'package:condorapp/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
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
          title: Center(child: Text("Iniciar Sesión")),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: "Usuario",
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: "Contraseña",
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final user = User(
                    username: _usernameController.text,
                    password: _passwordController.text,
                    email: '', firstName: '', lastName: '',
                  );
                  authProvider.login(user);
                },
                child: Text("Iniciar Sesión"),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: Text("¿No tienes una cuenta? Regístrate"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
