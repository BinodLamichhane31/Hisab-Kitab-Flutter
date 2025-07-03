import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/app/service_locator/service_locator.dart';
import 'package:hisab_kitab/core/common/snackbar/my_snackbar.dart';
import 'package:hisab_kitab/features/auth/domain/use_case/get_profile_usecase.dart';
import 'package:hisab_kitab/features/auth/domain/use_case/user_logout_usecase.dart';
import 'package:hisab_kitab/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:hisab_kitab/features/home/presentation/view_model/home_state.dart';
import 'package:hisab_kitab/features/products/presentation/view/login_view.dart';

class HomeViewModel extends Cubit<HomeState> {
  HomeViewModel() : super(HomeState.initial());

  void onTabTapped(int index) {
    if (index == 4 && state.user == null) {
      fetchProfile();
    }
    emit(state.copyWith(selectedIndex: index));
  }

  Future<void> logout(BuildContext context) async {
    final logoutUseCase = serviceLocator<UserLogoutUsecase>();
    final result = await logoutUseCase();
    result.fold(
      (failure) {
        showMySnackBar(
          context: context,
          message: "Login Failed",
          color: Colors.red,
        );
      },
      (success) {
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder:
                  (context) => BlocProvider.value(
                    value: serviceLocator<LoginViewModel>(),
                    child: LoginView(),
                  ),
            ),
            (route) => false,
          );
        }
      },
    );
  }

  Future<void> fetchProfile() async {
    emit(state.copyWith(isProfileLoading: true));
    final getProfileUsecase = serviceLocator<GetProfileUsecase>();
    final result = await getProfileUsecase();

    result.fold(
      (failure) {
        emit(state.copyWith(isProfileLoading: false));
      },
      (userEntity) {
        emit(state.copyWith(isProfileLoading: false, user: userEntity));
      },
    );
  }
}
