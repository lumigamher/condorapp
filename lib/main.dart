// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'api/api_client.dart';
import 'api/auth_api.dart';
import 'api/chat_api.dart';
import 'providers/auth_provider.dart';
import 'providers/chat_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_form_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/chat/chat_screen.dart';
import 'theme.dart';

void main() {
  final apiClient = ApiClient();

  runApp(MyApp(apiClient: apiClient));
}

class MyApp extends StatelessWidget {
  final ApiClient apiClient;

  MyApp({required this.apiClient});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(AuthAPI(apiClient))),
        ChangeNotifierProvider(create: (_) => ChatProvider(ChatAPI(apiClient))),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return MaterialApp(
            title: 'Mi Señor Jesus Chat App',
            theme: AppTheme.lightTheme,
            initialRoute: authProvider.isAuthenticated ? '/chat' : '/login',  // Redirige según autenticación
            routes: {
              '/': (context) => SplashScreen(),
              '/login': (context) => LoginScreen(),
              '/register': (context) => RegisterScreen(),
              '/signup_form': (context) => SignupFormScreen(),
              '/chat': (context) => ChatScreen(),
            },
          );
        },
      ),
    );
  }
}

