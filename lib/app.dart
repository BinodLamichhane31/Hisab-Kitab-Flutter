import 'package:flutter/material.dart';
import 'package:hisab_kitab/view/login_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: LoginView(), debugShowCheckedModeBanner: false);
  }
}
