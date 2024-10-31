import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'api/api_client.dart';
import 'api/auth_api.dart';
import 'api/chat_api.dart';
import 'providers/auth_provider.dart';
import 'providers/chat_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/sing_up_screen.dart';
import 'screens/splash_screen.dart';
import 'theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(AuthAPI(apiClient))),
        ChangeNotifierProvider(create: (_) => ChatProvider(ChatAPI(apiClient))),
      ],
      child: MaterialApp(
        title: 'Mi Señor Jesus Chat App',
        theme: AppTheme.lightTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignupScreen(),
        },
      ),
    );
  }
}
