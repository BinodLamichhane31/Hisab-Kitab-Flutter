import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/app/service_locator/service_locator.dart';
import 'package:hisab_kitab/app/shared_preferences/token_shared_prefs.dart';
import 'package:hisab_kitab/features/auth/presentation/view/login_view.dart';
import 'package:hisab_kitab/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:hisab_kitab/features/home/presentation/view/home_view.dart';
import 'package:hisab_kitab/features/home/presentation/view_model/home_view_model.dart';

class SplashViewModel extends Cubit<void> {
  final TokenSharedPrefs _tokenSharedPrefs;
  SplashViewModel(this._tokenSharedPrefs) : super(null);

  Future<void> init(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));
    final tokenResult = await _tokenSharedPrefs.getToken();
    tokenResult.fold(
      (failure) {
        _navigateTo(context, LoginView());
      },
      (token) {
        if (token != null && token.isNotEmpty) {
          _navigateTo(context, HomeView());
        } else {
          _navigateTo(context, LoginView());
        }
      },
    );
  }

  void _navigateTo(BuildContext context, Widget view) {
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            if (view is HomeView) {
              return BlocProvider.value(
                value: serviceLocator<HomeViewModel>(),
                child: HomeView(),
              );
            }
            return BlocProvider.value(
              value: serviceLocator<LoginViewModel>(),
              child: LoginView(),
            );
          },
        ),
      );
    }
  }
}
