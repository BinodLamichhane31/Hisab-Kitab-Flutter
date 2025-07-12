import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_kitab/features/auth/domain/entity/login_response_entity.dart';
import 'package:hisab_kitab/features/auth/domain/entity/user_entity.dart';
import 'package:hisab_kitab/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:mocktail/mocktail.dart';

import 'token.mock.dart';
import 'user_repository.mock.dart';

void main() {
  late UserRepositoryMock repository;
  late MockTokenSharedPrefs tokenSharedPrefs;
  late UserLoginUsecase usecase;

  const token = 'token';
  const user = UserEntity(
    userId: '1',
    fname: 'Binod',
    lname: 'Lamichhane',
    phone: '9876543210',
    email: 'binod@email.com',
    password: "binod",
  );

  final loginResponse = LoginResponseEntity(
    token: token,
    user: user,
    shops: [],
  );

  setUp(() {
    repository = UserRepositoryMock();
    tokenSharedPrefs = MockTokenSharedPrefs();
    usecase = UserLoginUsecase(
      repository: repository,
      tokenSharedPrefs: tokenSharedPrefs,
    );
  });

  test(
    'should call loginUser with correct email and password and save token',
    () async {
      // Arrange
      when(
        () => repository.loginUser(any(), any()),
      ).thenAnswer((_) async => Right(loginResponse));

      when(
        () => tokenSharedPrefs.saveToken(any()),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await usecase(
        const LoginUserParams(email: 'binod', password: 'binod'),
      );

      // Assert
      expect(result, Right(loginResponse));

      verify(() => repository.loginUser('binod', 'binod')).called(1);
      verify(() => tokenSharedPrefs.saveToken(token)).called(1);
      verifyNoMoreInteractions(repository);
      verifyNoMoreInteractions(tokenSharedPrefs);
    },
  );

  tearDown(() {
    reset(repository);
    reset(tokenSharedPrefs);
  });
}
