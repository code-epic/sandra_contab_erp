import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandra_contab_erp/core/theme/app_color.dart';



class AppTheme {
  static ThemeData light() => ThemeData(
    useMaterial3: true,
    fontFamily: 'Nunito',
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.brightBlue, // Usamos el azul como color semilla
      brightness: Brightness.light,
      primary: AppColors.brightBlue,
      onPrimary: AppColors.pureWhite,

      surface: AppColors.subtleBlue,
      onSurface: AppColors.navy,
      background: AppColors.subtleBlue,
      onBackground: AppColors.navy,
    ),
    // Personaliza los temas de texto
    textTheme: GoogleFonts.nunitoTextTheme().copyWith(
      bodyLarge: const TextStyle(color: AppColors.navy),
    ),
    scaffoldBackgroundColor: Colors.transparent,
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.brightBlue,
      textTheme: ButtonTextTheme.primary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.steelBlue,
      foregroundColor: AppColors.pureWhite,
    ),
  );
}
