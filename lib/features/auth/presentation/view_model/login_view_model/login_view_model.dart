import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/app/service_locator/service_locator.dart';
import 'package:hisab_kitab/core/common/snackbar/my_snackbar.dart';
import 'package:hisab_kitab/core/session/session_cubit.dart'; // <-- 1. IMPORT SessionCubit
import 'package:hisab_kitab/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:hisab_kitab/features/auth/presentation/view/forgot_password_view.dart';
import 'package:hisab_kitab/features/auth/presentation/view/signup_view.dart';
import 'package:hisab_kitab/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:hisab_kitab/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:hisab_kitab/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';
import 'package:hisab_kitab/features/home/presentation/view/home_view.dart';
import 'package:hisab_kitab/features/home/presentation/view_model/home_view_model.dart';
import 'package:hisab_kitab/features/shops/domain/entity/shop_entity.dart';
import 'package:hisab_kitab/features/shops/presentation/view/create_shop_view.dart';
import 'package:hisab_kitab/features/shops/presentation/view_model/shop_view_model.dart'; // <-- 2. IMPORT ShopEntity

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserLoginUsecase _loginUsecase;
  LoginViewModel(this._loginUsecase) : super(LoginState.initial()) {
    on<NavigateToSignupView>(_onNavigateToSignupView);
    on<NavigateToForgotPasswordView>(_onNavigateToForgotPasswordView);
    on<ShowHidePassword>(_onShowHidePassword);
    on<LoginIntoSystemEvent>(_onLoginWithEmailAndPassword);
  }

  void _onNavigateToSignupView(
    NavigateToSignupView event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder:
              (context) => BlocProvider.value(
                value: serviceLocator<SignupViewModel>(),
                child: SignupView(),
              ),
        ),
      );
    }
  }

  void _onNavigateToForgotPasswordView(
    NavigateToForgotPasswordView event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(builder: (_) => ForgotPasswordView()),
      );
    }
  }

  void _onShowHidePassword(ShowHidePassword event, Emitter<LoginState> emit) {
    emit(state.copyWith(isPasswordVisible: event.isVisible));
  }

  void _onLoginWithEmailAndPassword(
    LoginIntoSystemEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _loginUsecase(
      LoginUserParams(email: event.email, password: event.password),
    );
    emit(state.copyWith(isLoading: false));

    if (!event.context.mounted) return;

    result.fold(
      (failure) {
        debugPrint(failure.message);
        debugPrint(failure.message);
        showMySnackBar(
          context: event.context,
          message: failure.message,
          color: Colors.red,
        );
      },
      (loginResponse) {
        final sessionCubit = event.context.read<SessionCubit>();
        final shops = loginResponse.shops;

        ShopEntity? activeShop;
        if (loginResponse.currentShopId != null && shops.isNotEmpty) {
          activeShop = shops.firstWhere(
            (s) => s.shopId == loginResponse.currentShopId,
            orElse: () => shops.first,
          );
        } else if (shops.isNotEmpty) {
          activeShop = shops.first;
        }

        sessionCubit.onLoginSuccess(
          user: loginResponse.user,
          shops: shops,
          activeShop: activeShop,
        );

        showMySnackBar(context: event.context, message: "Login Success");

        if (shops.isEmpty) {
          Navigator.of(event.context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder:
                  (_) => BlocProvider(
                    create: (_) => serviceLocator<ShopViewModel>(),
                    child: const CreateShopView(),
                  ),
            ),
            (route) => false,
          );
        } else {
          Navigator.of(event.context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder:
                  (context) => BlocProvider(
                    create: (context) => serviceLocator<HomeViewModel>(),
                    child: const HomeView(),
                  ),
            ),
            (Route<dynamic> route) => false,
          );
        }
      },
    );
  }
}
