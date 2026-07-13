import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.lightBackground,
        colorScheme: const ColorScheme.light(
          primary: AppColors.physicalBase,
          secondary: AppColors.emotionalBase,
          tertiary: AppColors.intellectualBase,
          surface: AppColors.lightBackground,
          surfaceContainerLowest: Color(0xFFF5F5FA),
          surfaceContainerLow: Color(0xFFF0F0F7),
          surfaceContainer: Color(0xFFEBEBF2),
          surfaceContainerHigh: Color(0xFFE0E0EA),
          surfaceContainerHighest: Color(0xFFD5D5E0),
          onSurface: AppColors.lightText,
        ),
        textTheme: AppTextTheme.light,
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: AppColors.lightBackground.withOpacity(0.65),
          surfaceTintColor: Colors.transparent,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          elevation: 0,
          backgroundColor: AppColors.lightBackground.withOpacity(0.7),
          selectedItemColor: AppColors.physicalDark,
          unselectedItemColor: Colors.grey,
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.darkBackground,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.physicalBase,
          secondary: AppColors.emotionalBase,
          tertiary: AppColors.intellectualBase,
          surface: AppColors.darkBackground,
          surfaceContainerLowest: Color(0xFF0D0E14),
          surfaceContainerLow: Color(0xFF15171F),
          surfaceContainer: Color(0xFF1C1E27),
          surfaceContainerHigh: Color(0xFF262833),
          surfaceContainerHighest: Color(0xFF31333F),
          onSurface: AppColors.darkText,
        ),
        textTheme: AppTextTheme.dark,
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: AppColors.darkBackground.withOpacity(0.08),
          surfaceTintColor: Colors.transparent,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          elevation: 0,
          backgroundColor: const Color(0xFF121318).withOpacity(0.85),
          selectedItemColor: AppColors.physicalBase,
          unselectedItemColor: Colors.grey,
        ),
      );
}
