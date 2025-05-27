import 'package:flutter/material.dart';

ThemeData getHisabKitabTheme() {
  return ThemeData(
    primarySwatch: Colors.orange,
    fontFamily: 'Poppins Regular',
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: const TextStyle(
          fontFamily: 'Poppins SemiBold',
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    ),
  );
}
