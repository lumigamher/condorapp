import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:condorapp/theme.dart';
import 'package:condorapp/models/user.dart';
import 'package:condorapp/providers/auth_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  int _currentCarouselIndex = 0;

  final List<CarouselItem> _carouselItems = [
    CarouselItem(
      svg: '''
      <svg viewBox="0 0 200 200">
        <circle cx="100" cy="70" r="30" fill="#133E87"/>
        <path d="M60,120 Q100,180 140,120" fill="none" stroke="#608BC1" stroke-width="4"/>
        <rect x="85" y="100" width="30" height="60" fill="#133E87"/>
      </svg>
      ''',
      title: 'Conexión Espiritual',
      description: 'Un espacio para fortalecer tu fe y encontrar guía espiritual',
    ),
    CarouselItem(
      svg: '''
      <svg viewBox="0 0 200 200">
        <rect x="20" y="40" width="120" height="40" rx="20" fill="#608BC1"/>
        <rect x="60" y="90" width="120" height="40" rx="20" fill="#133E87"/>
        <rect x="20" y="140" width="120" height="40" rx="20" fill="#608BC1"/>
      </svg>
      ''',
      title: 'Conversación Significativa',
      description: 'Dialoga y recibe consejos basados en la sabiduría divina',
    ),
    CarouselItem(
      svg: '''
      <svg viewBox="0 0 200 200">
        <path d="M40,50 L160,50 L160,150 Q100,130 40,150 Z" fill="#133E87"/>
        <path d="M40,50 Q100,70 160,50" fill="none" stroke="#608BC1" stroke-width="4"/>
        <line x1="100" y1="70" x2="100" y2="140" stroke="#608BC1" stroke-width="2"/>
      </svg>
      ''',
      title: 'Sabiduría Divina',
      description: 'Aprende y crece con respuestas basadas en las escrituras',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Theme(
      data: AppTheme.lightTheme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Iniciar Sesión"),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              const SizedBox(height: 24),

              // Carrusel
              FlutterCarousel(
                items: _carouselItems.map((item) => _buildCarouselItem(item)).toList(),
                options: CarouselOptions(
                  height: 280.0,
                  showIndicator: false,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 5),
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentCarouselIndex = index;
                    });
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Indicador del carrusel
              Center(
                child: AnimatedSmoothIndicator(
                  activeIndex: _currentCarouselIndex,
                  count: _carouselItems.length,
                  effect: ExpandingDotsEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: AppColors.primary,
                    dotColor: AppColors.primary.withOpacity(0.2),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Campo de usuario
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Usuario",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.primary.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
              const SizedBox(height: 16),

              // Campo de contraseña
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Contraseña",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.primary.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
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
                child: const Text("Iniciar Sesión", 
                  style: TextStyle(fontSize: 16)
                ),
              ),
              const SizedBox(height: 24),

              // Texto de redes sociales
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
                  _buildSocialButton(
                    'assets/google.svg',
                    () {},
                    size: 28,
                  ),
                  const SizedBox(width: 16),
                  _buildSocialButton(
                    'assets/facebook.svg',
                    () {},
                    size: 30,
                  ),
                  const SizedBox(width: 16),
                  _buildSocialButton(
                    'assets/apple.svg',
                    () {},
                    size: 28,
                  ),
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

  Widget _buildCarouselItem(CarouselItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 150,
            child: SvgPicture.string(
              item.svg,
              width: 150,
              height: 150,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              item.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(String assetName, VoidCallback onPressed, {double size = 30}) {
    return GestureDetector(
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: SvgPicture.asset(
                assetName,
                width: size,
                height: size,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CarouselItem {
  final String svg;
  final String title;
  final String description;

  CarouselItem({
    required this.svg,
    required this.title,
    required this.description,
  });
}