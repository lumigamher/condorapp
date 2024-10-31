import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF88C9BF); // Verde calmante
  static const Color secondary = Color(0xFFB1E5D3); // Verde claro
  static const Color background = Color(0xFFF5F5F5); // Fondo suave gris
  static const Color accent = Color(0xFF5C6BC0); // Azul suave para énfasis
  static const Color textPrimary = Color(0xFF424242); // Gris oscuro para texto
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.secondary,
        onSecondary: AppColors.textPrimary,
        background: AppColors.background,
        onBackground: AppColors.textPrimary,
        surface: Colors.white,
        onSurface: AppColors.textPrimary,
        error: Colors.red,
        onError: Colors.white,
        tertiary: AppColors.accent,
        onTertiary: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.background,
      
      appBarTheme: AppBarTheme(
        color: AppColors.background,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accent,
          textStyle: TextStyle(fontSize: 16),
        ),
      ),
      
      textTheme: TextTheme(
        headlineSmall: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w600),
        bodyMedium: TextStyle(color: AppColors.textPrimary),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.all(20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: Colors.grey[400]),
      ),
    );
  }
}
