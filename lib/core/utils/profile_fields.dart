import 'package:flutter/material.dart';

Widget buildInputField(
  IconData icon,
  String label,
  String value,
  ThemeData theme,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: theme.textTheme.bodyLarge?.color,
        ),
      ),
      SizedBox(height: 5),
      TextField(
        enabled: false,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: theme.iconTheme.color),
          hintText: value,
          hintStyle: TextStyle(color: theme.hintColor),
          filled: true,
          fillColor:
              theme.inputDecorationTheme.fillColor ??
              (theme.brightness == Brightness.dark
                  ? Colors.grey.shade800
                  : Colors.grey.shade100),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    ],
  );
}
