import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/app/service_locator/service_locator.dart';
import 'package:hisab_kitab/core/session/session_cubit.dart';
import 'package:hisab_kitab/features/auth/domain/use_case/user_logout_usecase.dart';
import 'package:hisab_kitab/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:hisab_kitab/features/home/presentation/view_model/home_state.dart';
import 'package:hisab_kitab/features/products/presentation/view/login_view.dart';

class HomeViewModel extends Cubit<HomeState> {
  HomeViewModel() : super(HomeState.initial());

  void onTabTapped(int index) {
    emit(state.copyWith(selectedIndex: index));
  }

  Future<void> logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(false),
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () => Navigator.of(dialogContext).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    final logoutUseCase = serviceLocator<UserLogoutUsecase>();

    await logoutUseCase();

    if (context.mounted) {
      context.read<SessionCubit>().onLogout();

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
  }
}
