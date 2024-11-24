import 'package:flutter/material.dart';

abstract class AppTheme {
  static ThemeData get lightTheme => ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey.shade300,
        colorScheme: ColorScheme.light(
          primary: Colors.grey.shade500,
          surface: Colors.grey.shade300,
          secondary: Colors.grey.shade200,
          tertiary: Colors.grey.shade100,
          inversePrimary: Colors.grey.shade900,
        ),
        primaryTextTheme: const TextTheme(
          titleMedium: TextStyle(
            fontSize: 16,
          ),
        ),
      );
}
