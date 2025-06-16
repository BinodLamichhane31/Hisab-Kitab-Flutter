import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/features/splash/presentation/view_model/splash_view_model.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashViewModel>().init(context);
    });
    return Scaffold(
      backgroundColor: const Color(0xffffe5d3),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo/app_logo_black.png', height: 100),
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
