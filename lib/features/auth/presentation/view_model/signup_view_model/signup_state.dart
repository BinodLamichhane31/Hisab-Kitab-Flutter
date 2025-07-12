import 'package:equatable/equatable.dart';

class SignupState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;

  const SignupState({
    required this.isLoading,
    required this.isSuccess,
    required this.isPasswordVisible,
    required this.isConfirmPasswordVisible,
  });
  const SignupState.initial()
    : isLoading = false,
      isSuccess = false,
      isPasswordVisible = false,
      isConfirmPasswordVisible = false;

  SignupState copyWith({
    bool? isLoading,
    bool? isSuccess,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
  }) {
    return SignupState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isSuccess,
    isPasswordVisible,
    isConfirmPasswordVisible,
  ];
}
