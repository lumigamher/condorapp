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
import 'screens/chat/chat_screen.dart';
import 'theme.dart';

void main() async {
  // Asegurar que Flutter esté inicializado
  WidgetsFlutterBinding.ensureInitialized();
  
  // Crear instancia de ApiClient
  final apiClient = ApiClient();

  // Crear las APIs
  final authAPI = AuthAPI(apiClient);
  final chatAPI = ChatAPI(apiClient);

  // Crear los providers
  final authProvider = AuthProvider(authAPI);
  
  // Cargar el token guardado si existe
  await authProvider.loadToken();

  // Iniciar la aplicación
  runApp(MyApp(
    apiClient: apiClient,
    authAPI: authAPI,
    chatAPI: chatAPI,
    initialAuthProvider: authProvider,
  ));
}

class MyApp extends StatelessWidget {
  final ApiClient apiClient;
  final AuthAPI authAPI;
  final ChatAPI chatAPI;
  final AuthProvider initialAuthProvider;

  const MyApp({
    super.key,
    required this.apiClient,
    required this.authAPI,
    required this.chatAPI,
    required this.initialAuthProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Proveedor del ApiClient base
        Provider<ApiClient>.value(value: apiClient),
        
        // Proveedores de APIs
        Provider<AuthAPI>.value(value: authAPI),
        Provider<ChatAPI>.value(value: chatAPI),
        
        // Provider de autenticación
        ChangeNotifierProvider<AuthProvider>.value(
          value: initialAuthProvider,
        ),
        
        // Provider de chat que depende de ChatAPI
        ChangeNotifierProxyProvider<ChatAPI, ChatProvider>(
          create: (context) => ChatProvider(chatAPI),
          update: (context, chatAPI, previous) {
            final provider = ChatProvider(chatAPI);
            if (previous != null) {
              provider.updateFrom(previous);
            }
            return provider;
          },
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return MaterialApp(
            title: 'Mi Señor Jesus Chat App',
            theme: AppTheme.lightTheme,
            initialRoute: _getInitialRoute(authProvider),
            routes: {
              '/': (context) => const SplashScreen(),
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/signup_form': (context) => const SignupFormScreen(),
              '/chat': (context) => const ChatScreen(),
            },
            // Middleware para proteger rutas
            onGenerateRoute: (settings) {
              // Si la ruta requiere autenticación y el usuario no está autenticado
              if (_requiresAuth(settings.name) && !authProvider.isAuthenticated) {
                return MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                );
              }
              return null;
            },
            builder: (context, child) {
              return Stack(
                children: [
                  child!,
                  // Indicador de carga global
                  if (authProvider.isLoading)
                    Container(
                      color: Colors.black54,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              );
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }

  // Determina la ruta inicial basada en el estado de autenticación
  String _getInitialRoute(AuthProvider authProvider) {
    if (authProvider.isLoading) {
      return '/'; // Muestra el SplashScreen mientras carga
    }
    if (authProvider.isAuthenticated) {
      return '/chat';
    }
    return '/login';
  }

  // Determina si una ruta requiere autenticación
  bool _requiresAuth(String? routeName) {
    return routeName == '/chat';
  }
}

// Configuración de rutas
class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String signupForm = '/signup_form';
  static const String chat = '/chat';

  // Define qué rutas requieren autenticación
  static final Set<String> authenticatedRoutes = {
    chat,
  };

  // Define qué rutas son públicas
  static final Set<String> publicRoutes = {
    splash,
    login,
    register,
    signupForm,
  };
}

// Widget para manejar la carga inicial y verificación de autenticación
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await Future.delayed(const Duration(seconds: 2)); // Simular carga inicial
    
    if (mounted) {
      if (authProvider.isAuthenticated) {
        Navigator.pushReplacementNamed(context, '/chat');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Aquí puedes poner tu logo o imagen de splash
            Icon(
              Icons.chat,
              size: 80,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              'Mi Señor Jesus Chat App',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}