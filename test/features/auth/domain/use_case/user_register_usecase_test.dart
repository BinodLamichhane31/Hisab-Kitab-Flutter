import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/auth/domain/entity/user_entity.dart';
import 'package:hisab_kitab/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:mocktail/mocktail.dart';

import 'user_repository.mock.dart';

void main() {
  late UserRepositoryMock mockRepository;
  late UserRegisterUsecase usecase;

  setUp(() {
    mockRepository = UserRepositoryMock();
    usecase = UserRegisterUsecase(repository: mockRepository);
  });

  const registerParams = RegisterUserParams(
    fname: 'Binod',
    lname: 'Lamichhane',
    email: 'binod@email.com',
    phone: '9800000000',
    password: 'binod123',
  );

  final expectedUserEntity = UserEntity(
    fname: registerParams.fname,
    lname: registerParams.lname,
    email: registerParams.email,
    phone: registerParams.phone,
    password: registerParams.password,
  );

  test('should register user successfully and return Right(void)', () async {
    // Arrange
    when(
      () => mockRepository.registerUser(expectedUserEntity),
    ).thenAnswer((_) async => const Right(null));

    // Act
    final result = await usecase(registerParams);

    // Assert
    expect(result, const Right(null));
    verify(() => mockRepository.registerUser(expectedUserEntity)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Left(Failure) when registration fails', () async {
    // Arrange
    final failure = ApiFailure(message: 'Email already exists');
    when(
      () => mockRepository.registerUser(expectedUserEntity),
    ).thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase(registerParams);

    // Assert
    expect(result, Left(failure));
    verify(() => mockRepository.registerUser(expectedUserEntity)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  tearDown(() {
    reset(mockRepository);
  });
}
