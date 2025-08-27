import 'package:flutter/material.dart';


class AppColors {
  static const Color navy   = Color(0xFF1C2331);
  static const Color ocean  = Color(0xFF2E5984);
  static const Color sky    = Color(0xFF4A90E2);
  static const Color gold   = Color(0xFFF2C249);
  static const Color cloud  = Color(0xFFF5F7FA);
  static const Color silver = Color(0xFFE0E6ED);
  static const Color orangeBackground = Color(0xFFFF8C42);
  static const Color brightBlue = Color(0xFF3366FF);
  static const Color pureWhite = Color(0xFFF6ED);
  static const Color darkOrange = Color(0xFFE05B00);
  // Azules cercanos a grises y muy sutiles
  static const Color subtleBlue = Color(0xFFB0BEC5); // Azul claro y apagado, casi gris
  static const Color steelBlue = Color(0xFF607D8B); // Un azul más oscuro y con más gris
  static const Color lightSlate = Color(0xFF78909C); // Un gris con un toque de azul
  static const Color paleBlue = Color(0xFFCFD8DC);  // Muy similar a un gris muy claro

// Tonos azul-cercanos al blanco (ordenados de más claro → más azul)
  static const Color blueMedium   = Color(0xFFF4F8FB);  // casi blanco
  static const Color blue  = Color(0xFFE1EBF5);  // muy claro
  static const Color blueAlpha  = Color(0xFFC8D9EC);  // claro
  static const Color blueMediumAlpha  = Color(0xFFA9C3E0);  // medio-claro
  static const Color blueHighAlpha  = Color(0xFF8BAED3);

  static const Color vividNavy   = Color(0xFF003366);   // azul marino profundo
  static const Color electric    = Color(0xFF007BFF);   // azul eléctrico
  static const Color cyanPop     = Color(0xFF00C2FF);   // cian brillante
  static const Color tealPop     = Color(0xFF009688);   // verde azulado vibrante

// Naranjas y amarillos con fuerza
  static const Color mango       = Color(0xFFFF6F00);   // naranja intenso
  static const Color sunGlow     = Color(0xFFFFC400);   // amarillo ácido
  static const Color coral       = Color(0xFFFF5252);   // coral neón

// Blancos y grises limpios
  static const Color snow        = Color(0xFFF7F9FC);
  static const Color softGrey    = Color(0xFFE5EAF2);
  static const Color steelGrey   = Color(0xFF8E9AAB);

  static const Color primaryOrange = Color(0xFFF7BD69);
  static const Color primaryTeal = Color(0xFF88D3CE);
  static const Color primaryPurple = Color(0xFFC0A2D3);



  static Color yellowSoft = Color(0xFFF7BD69).withOpacity(0.15);
  static Color yellowSoftmax = Color(0xFFF7BD69).withOpacity(0.9);
  static Color purpleSoft = Color(0xFFC0A2D3).withOpacity(0.15);
  static Color purpleSoftmax = Color(0xFFC0A2D3).withOpacity(0.9);
  static Color greenSoft = Color(0xFF88D3CE).withOpacity(0.15);
  static Color greenSoftmax = Color(0xFF88D3CE).withOpacity(0.9);
  static const Color textVividNavy = Color(0xFF1A237E);
  static const Color backgroundLightGrey = Color(0xFFF5F5F5);
}

// Ejemplo de cómo usarla en un tema
ThemeData lightTheme = ThemeData(
  primaryColor: AppColors.brightBlue, // Usar el azul para el color principal
  scaffoldBackgroundColor: AppColors.orangeBackground, // Usar el naranja para el fondo
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.pureWhite), // Texto en blanco para mayor legibilidad
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: AppColors.brightBlue, // Botones en azul
    textTheme: ButtonTextTheme.primary,
  ),
);