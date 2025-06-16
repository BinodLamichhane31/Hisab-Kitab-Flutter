class SignupState {
  final bool isLoading;
  final bool isSuccess;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;

  SignupState({
    required this.isLoading,
    required this.isSuccess,
    required this.isPasswordVisible,
    required this.isConfirmPasswordVisible,
  });
  SignupState.initial()
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
}
