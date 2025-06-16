import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/features/auth/presentation/view/login_view.dart';
import 'package:hisab_kitab/features/auth/presentation/view_model/signup_view_model/signup_event.dart';
import 'package:hisab_kitab/features/auth/presentation/view_model/signup_view_model/signup_state.dart';

class SignupViewModel extends Bloc<SignupEvent, SignupState> {
  SignupViewModel() : super(SignupState.initial()) {
    on<NavigateToLoginView>(_onNavigateToLoginView);
    on<ShowHidePassword>(_onShowHidePassword);
    on<ShowHideConfirmPassword>(_onShowHideConfirmPassword);
  }

  void _onNavigateToLoginView(
    NavigateToLoginView event,
    Emitter<SignupState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(builder: (_) => LoginView()),
      );
    }
  }

  void _onShowHidePassword(ShowHidePassword event, Emitter<SignupState> emit) {
    emit(state.copyWith(isPasswordVisible: event.isVisible));
  }

  void _onShowHideConfirmPassword(
    ShowHideConfirmPassword event,
    Emitter<SignupState> emit,
  ) {
    emit(state.copyWith(isConfirmPasswordVisible: event.isVisible));
  }

  // Future<void> _onRegisterUser(
  //   RegisterEvent event,
  //   Emitter<SignupState> emit,
  // ) {}
}
