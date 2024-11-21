import 'package:flutter/material.dart';

class AppColors {
  // Color principal - Azul oscuro 
  static const Color primary = Color(0xFF133E87);
  
  // Color secundario - Azul claro con toque de gris
  static const Color secondary = Color(0xFFCBDCEB);
  
  // Fondo - Crema suave
  static const Color background = Color(0xFFF3F3E0);
  
  // Acento - Azul medio
  static const Color accent = Color(0xFF608BC1);
  
  // Texto - Gris azulado oscuro (mantenemos el mismo para buena legibilidad)
  static const Color textPrimary = Color(0xFF2C3E50);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.secondary,
        onSecondary: AppColors.textPrimary,
        surface: Colors.white,
        onSurface: AppColors.textPrimary,
        error: Color(0xFFE76F51),
        onError: Colors.white,
        tertiary: AppColors.accent,
        onTertiary: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.background,
      
      appBarTheme: const AppBarTheme(
        color: AppColors.background,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accent,
          textStyle: const TextStyle(
            fontSize: 16,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textPrimary,
          letterSpacing: 0.5,
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          elevation: 0,
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                return Colors.white.withOpacity(0.1);
              }
              return null;
            },
          ),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.secondary.withOpacity(0.3),
        contentPadding: const EdgeInsets.all(20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(
          color: AppColors.textPrimary.withOpacity(0.5),
          letterSpacing: 0.5,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.primary.withOpacity(0.1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.primary.withOpacity(0.2),
            width: 2,
          ),
        ),
      ),
      
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: AppColors.primary.withOpacity(0.1),
          ),
        ),
      ),
    );
  }
}