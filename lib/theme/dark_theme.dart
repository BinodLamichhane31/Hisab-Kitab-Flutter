import 'package:flutter/material.dart';

ThemeData getDarkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.orange,
    fontFamily: 'Poppins Regular',
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange.shade700,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: const TextStyle(
          fontSize: 20,
          fontFamily: 'Poppins SemiBold',
          color: Colors.white,
        ),
      ),
    ),
  );
}
