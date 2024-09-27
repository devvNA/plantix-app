import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taniku_app/app/core/theme/app_color.dart';

ThemeData myTheme = ThemeData(
  useMaterial3: false,
  textTheme: GoogleFonts.poppinsTextTheme(),
  appBarTheme: const AppBarTheme(backgroundColor: AppColors.primary),
  bottomAppBarTheme: const BottomAppBarTheme(color: AppColors.primary),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
    ),
  ),
);
