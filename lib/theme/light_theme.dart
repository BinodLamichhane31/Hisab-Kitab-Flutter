import 'package:flutter/material.dart';

ThemeData getLightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.orange,
    fontFamily: 'Poppins Regular',
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: const TextStyle(
          fontSize: 20,
          fontFamily: 'Poppins SemiBold',
          color: Colors.blue,
        ),
      ),
    ),
  );
}
