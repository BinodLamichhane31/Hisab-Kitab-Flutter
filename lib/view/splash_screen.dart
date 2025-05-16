import 'package:flutter/material.dart';
import 'package:hisab_kitab/view/login_view.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => LoginView()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffe5d3),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo/app_logo.png', height: 100),
            SizedBox(height: 50),
            CircularProgressIndicator(
              color: Colors.orange,
              // you can set color
            ),
            SizedBox(height: 50),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    text: "Simplify Your Shop's Hisab",
                  ),
                  TextSpan(
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                    text: "Kitab",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
