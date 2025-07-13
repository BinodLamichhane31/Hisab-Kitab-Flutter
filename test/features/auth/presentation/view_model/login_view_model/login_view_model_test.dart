import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:hisab_kitab/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:hisab_kitab/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:hisab_kitab/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:mocktail/mocktail.dart';

class MockUserLoginUsecase extends Mock implements UserLoginUsecase {}

class MockBuildContext extends Mock implements BuildContext {}

class FakeBuildContext extends Fake implements BuildContext {
  @override
  bool get mounted => false;
}

void main() {
  group('LoginViewModel', () {
    late LoginViewModel loginViewModel;
    late MockUserLoginUsecase mockLoginUsecase;
    late MockBuildContext mockBuildContext;

    setUp(() {
      mockLoginUsecase = MockUserLoginUsecase();
      mockBuildContext = MockBuildContext();
      loginViewModel = LoginViewModel(mockLoginUsecase);

      registerFallbackValue(LoginUserParams.initial());
      registerFallbackValue(mockBuildContext);
    });

    tearDown(() {
      loginViewModel.close();
    });

    blocTest<LoginViewModel, LoginState>(
      'should toggle password visibility when ShowHidePassword event is added',
      build: () => loginViewModel,
      act:
          (bloc) => bloc.add(
            ShowHidePassword(isVisible: true, context: MockBuildContext()),
          ),
      expect: () => [LoginState.initial().copyWith(isPasswordVisible: true)],
    );

    blocTest<LoginViewModel, LoginState>(
      'should emit loading states when login fails',
      build: () {
        when(
          () => mockLoginUsecase.call(any()),
        ).thenAnswer((_) async => Left(ApiFailure(message: 'Login failed')));
        return loginViewModel;
      },
      act:
          (bloc) => bloc.add(
            LoginIntoSystemEvent(
              email: 'test@example.com',
              password: 'password123',
              context: FakeBuildContext(),
            ),
          ),
      expect:
          () => [
            LoginState.initial().copyWith(isLoading: true),
            LoginState.initial().copyWith(isLoading: false),
          ],
    );
  });
}
