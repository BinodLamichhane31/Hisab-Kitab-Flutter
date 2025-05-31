import 'package:flutter/material.dart';
import 'package:hisab_kitab/theme/dark_theme.dart';
import 'package:hisab_kitab/theme/light_theme.dart';
import 'package:hisab_kitab/view/dashboard_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DashboardView(),
      debugShowCheckedModeBanner: false,
      theme: getLightTheme(),
      darkTheme: getDarkTheme(),
      themeMode: ThemeMode.system,
    );
  }
}
