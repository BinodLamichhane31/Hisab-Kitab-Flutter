import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_kitab/app/shared_preferences/token_shared_prefs.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/core/session/session_cubit.dart';
import 'package:hisab_kitab/features/auth/domain/entity/user_entity.dart';
import 'package:hisab_kitab/features/auth/domain/use_case/get_profile_usecase.dart';
import 'package:hisab_kitab/features/auth/presentation/view/login_view.dart';
import 'package:hisab_kitab/features/home/presentation/view/home_view.dart';
import 'package:hisab_kitab/features/shops/domain/entity/shop_entity.dart';
import 'package:hisab_kitab/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:mocktail/mocktail.dart';

class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

class MockGetProfileUsecase extends Mock implements GetProfileUsecase {}

class MockSessionCubit extends Mock implements SessionCubit {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late SplashViewModel splashViewModel;
  late MockTokenSharedPrefs mockTokenSharedPrefs;
  late MockGetProfileUsecase mockGetProfileUsecase;
  late MockSessionCubit mockSessionCubit;
  late MockNavigatorObserver mockNavigatorObserver;

  setUp(() {
    mockTokenSharedPrefs = MockTokenSharedPrefs();
    mockGetProfileUsecase = MockGetProfileUsecase();
    mockSessionCubit = MockSessionCubit();
    mockNavigatorObserver = MockNavigatorObserver();

    splashViewModel = SplashViewModel(
      mockTokenSharedPrefs,
      mockGetProfileUsecase,
    );
  });

  Widget createTestApp(Widget child) {
    return MaterialApp(
      navigatorObservers: [mockNavigatorObserver],
      home: BlocProvider<SessionCubit>.value(
        value: mockSessionCubit,
        child: child,
      ),
    );
  }

  group('SplashViewModel', () {
    test('should be initialized correctly', () {
      // Assert
      expect(splashViewModel, isA<SplashViewModel>());
    });
  });
}
