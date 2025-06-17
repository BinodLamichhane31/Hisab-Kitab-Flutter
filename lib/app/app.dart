import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/app/service_locator/service_locator.dart';
import 'package:hisab_kitab/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:hisab_kitab/app/theme/dark_theme.dart';
import 'package:hisab_kitab/app/theme/light_theme.dart';
import 'package:hisab_kitab/features/splash/presentation/view/splash_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Hisab Kitab",
      debugShowCheckedModeBanner: false,
      theme: getLightTheme(),
      darkTheme: getDarkTheme(),
      themeMode: ThemeMode.system,
      home: BlocProvider.value(
        value: serviceLocator<SplashViewModel>(),
        child: SplashScreen(),
      ),
    );
  }
}
