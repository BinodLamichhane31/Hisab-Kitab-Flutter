import 'package:flutter/material.dart';

@immutable
sealed class SignupEvent {}

class NavigateToLoginView extends SignupEvent {
  final BuildContext context;
  final Widget destination;

  NavigateToLoginView({required this.context, required this.destination});
}

class RegisterUserEvent extends SignupEvent {
  final BuildContext context;
  final String fname;
  final String lname;
  final String phone;
  final String email;
  final String password;
  final String confirmPassword;

  RegisterUserEvent({
    required this.context,
    required this.fname,
    required this.lname,
    required this.phone,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
}

class ShowHidePassword extends SignupEvent {
  final BuildContext context;
  final bool isVisible;

  ShowHidePassword({required this.context, required this.isVisible});
}

class ShowHideConfirmPassword extends SignupEvent {
  final BuildContext context;
  final bool isVisible;

  ShowHideConfirmPassword({required this.context, required this.isVisible});
}
