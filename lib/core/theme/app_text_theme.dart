import 'package:flutter/material.dart';

class AppTextTheme {
  AppTextTheme._();

  static const TextTheme light = TextTheme(
    headlineLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: Color(0xFF1C1B1F),
    ),
    headlineMedium: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      color: Color(0xFF1C1B1F),
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Color(0xFF1C1B1F),
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Color(0xFF1C1B1F),
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Color(0xFF1C1B1F),
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Color(0xFF1C1B1F),
    ),
  );

  static const TextTheme dark = TextTheme(
    headlineLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: Color(0xFFE6E1E5),
    ),
    headlineMedium: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      color: Color(0xFFE6E1E5),
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Color(0xFFE6E1E5),
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Color(0xFFE6E1E5),
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Color(0xFFE6E1E5),
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Color(0xFFE6E1E5),
    ),
  );
}
