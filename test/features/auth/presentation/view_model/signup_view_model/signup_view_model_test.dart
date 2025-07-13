import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_kitab/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:hisab_kitab/features/auth/presentation/view_model/signup_view_model/signup_event.dart';
import 'package:hisab_kitab/features/auth/presentation/view_model/signup_view_model/signup_state.dart';
import 'package:hisab_kitab/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';
import 'package:mocktail/mocktail.dart';

void mockSnackBar() {
  TestWidgetsFlutterBinding.ensureInitialized();
}

class MockUserRegisterUsecase extends Mock implements UserRegisterUsecase {}

class FakeBuildContext extends Fake implements BuildContext {
  @override
  bool get mounted => true;
}

void main() {
  late MockUserRegisterUsecase mockUserRegisterUsecase;
  late SignupViewModel signupViewModel;

  setUpAll(() {
    registerFallbackValue(
      const RegisterUserParams(
        fname: 'Test',
        lname: 'User',
        email: 'test@example.com',
        phone: '1234567890',
        password: 'password123',
      ),
    );
  });

  setUp(() {
    mockUserRegisterUsecase = MockUserRegisterUsecase();
    signupViewModel = SignupViewModel(mockUserRegisterUsecase);
  });

  tearDown(() {
    signupViewModel.close();
  });

  group('SignupViewModel', () {
    blocTest<SignupViewModel, SignupState>(
      'should toggle password visibility when ShowHidePassword event is added',
      build: () => signupViewModel,
      act:
          (bloc) => bloc.add(
            ShowHidePassword(context: FakeBuildContext(), isVisible: true),
          ),
      expect: () => [SignupState.initial().copyWith(isPasswordVisible: true)],
    );

    blocTest<SignupViewModel, SignupState>(
      'emits [SignupState] with isConfirmPasswordVisible = false',
      build: () => signupViewModel,
      seed:
          () => SignupState.initial().copyWith(isConfirmPasswordVisible: true),
      act:
          (bloc) => bloc.add(
            ShowHideConfirmPassword(
              context: FakeBuildContext(),
              isVisible: false,
            ),
          ),
      expect:
          () => [
            SignupState.initial().copyWith(isConfirmPasswordVisible: false),
          ],
    );
  });
}
