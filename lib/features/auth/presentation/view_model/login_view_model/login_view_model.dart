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
    // Note: NavigateToHomeView event is no longer needed here, but we'll leave it for now.
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

  // ------------------- THE UPDATED METHOD -------------------
  void _onLoginWithEmailAndPassword(
    LoginIntoSystemEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _loginUsecase(
      LoginUserParams(email: event.email, password: event.password),
    );
    // It's better to set isLoading to false once, after the async call.
    emit(state.copyWith(isLoading: false));

    // It's crucial to check if the widget is still in the tree after an async gap.
    if (!event.context.mounted) return;

    result.fold(
      (failure) {
        // The failure case remains the same
        debugPrint(failure.message);
        showMySnackBar(
          context: event.context,
          message: failure.message, // Use the actual failure message
          color: Colors.red,
        );
      },
      (loginResponse) {
        // <-- 4. The success value is now `loginResponse`
        // Get the global session cubit from the context
        final sessionCubit = event.context.read<SessionCubit>();
        final shops = loginResponse.shops;

        // Determine which shop is active
        ShopEntity? activeShop;
        if (loginResponse.currentShopId != null && shops.isNotEmpty) {
          // Find the shop with the matching ID, or default to the first shop if not found
          activeShop = shops.firstWhere(
            (s) => s.shopId == loginResponse.currentShopId,
            orElse: () => shops.first,
          );
        } else if (shops.isNotEmpty) {
          // If no currentShopId is specified, just use the first one
          activeShop = shops.first;
        }

        // Update the global session state with all the user and shop info
        sessionCubit.onLoginSuccess(
          user: loginResponse.user,
          shops: shops,
          activeShop: activeShop,
        );

        showMySnackBar(context: event.context, message: "Login Success");

        // Now, decide where to navigate based on whether the user has shops
        if (shops.isEmpty) {
          // If the user has no shops, show the dialog to create one
          // showCreateShopDialog(event.context);
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
          // If they have shops, navigate to the home screen and clear the back stack
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
