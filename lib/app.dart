import 'package:flutter/material.dart';
import 'package:hisab_kitab/theme/theme_data.dart';
import 'package:hisab_kitab/view/splash_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      theme: getHisabKitabTheme(),
    );
  }
}
