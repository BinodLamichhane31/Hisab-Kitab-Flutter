// In lib/app/app.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/app/service_locator/service_locator.dart';
import 'package:hisab_kitab/core/session/session_cubit.dart';
import 'package:hisab_kitab/features/splash/presentation/view/splash_screen.dart';
import 'package:hisab_kitab/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:hisab_kitab/app/theme/dark_theme.dart';
import 'package:hisab_kitab/app/theme/light_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // SessionCubit is provided at the very top level of the widget tree.
    return BlocProvider(
      create: (context) => serviceLocator<SessionCubit>(),
      child: MaterialApp(
        title: "Hisab Kitab",
        debugShowCheckedModeBanner: false,
        theme: getLightTheme(),
        darkTheme: getDarkTheme(),
        themeMode: ThemeMode.system,
        // THE FIX IS HERE: Use a Builder
        home: Builder(
          builder: (context) {
            // The `context` provided by this builder is now guaranteed
            // to be under the MaterialApp and can safely be used for navigation.
            return BlocProvider(
              // Your SplashViewModel is scoped only to the SplashScreen
              create: (context) => serviceLocator<SplashViewModel>(),
              child: const SplashScreen(),
            );
          },
        ),
      ),
    );
  }
}
