import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hisab_kitab/features/home/presentation/view_model/home_view_model.dart';
import 'package:hisab_kitab/features/home/presentation/view_model/home_state.dart';
import 'package:hisab_kitab/features/auth/domain/entity/user_entity.dart';

void main() {
  group('HomeViewModel', () {
    late HomeViewModel homeViewModel;

    setUp(() {
      homeViewModel = HomeViewModel();
    });

    tearDown(() {
      homeViewModel.close();
    });

    test('initial state is correct', () {
      expect(homeViewModel.state, const HomeState(selectedIndex: 0));
    });

    blocTest<HomeViewModel, HomeState>(
      'emits state with updated selectedIndex when onTabTapped is called',
      build: () => HomeViewModel(),
      act: (bloc) => bloc.onTabTapped(2),
      expect: () => [const HomeState(selectedIndex: 2)],
    );

    blocTest<HomeViewModel, HomeState>(
      'emits state with updated selectedIndex when onTabTapped is called multiple times',
      build: () => HomeViewModel(),
      act: (bloc) {
        bloc.onTabTapped(1);
        bloc.onTabTapped(3);
        bloc.onTabTapped(0);
      },
      expect:
          () => [
            const HomeState(selectedIndex: 1),
            const HomeState(selectedIndex: 3),
            const HomeState(selectedIndex: 0),
          ],
    );

    blocTest<HomeViewModel, HomeState>(
      'emits state with updated user when user is set',
      build: () => HomeViewModel(),
      act: (bloc) {
        final user = UserEntity(
          userId: '1',
          fname: 'John',
          lname: 'Doe',
          email: 'john@example.com',
          phone: '1234567890',
          password: 'password123',
        );
        bloc.emit(bloc.state.copyWith(user: user));
      },
      expect:
          () => [
            HomeState(
              selectedIndex: 0,
              user: UserEntity(
                userId: '1',
                fname: 'John',
                lname: 'Doe',
                email: 'john@example.com',
                phone: '1234567890',
                password: 'password123',
              ),
            ),
          ],
    );

    blocTest<HomeViewModel, HomeState>(
      'emits state with updated isProfileLoading when loading state changes',
      build: () => HomeViewModel(),
      act: (bloc) {
        bloc.emit(bloc.state.copyWith(isProfileLoading: true));
        bloc.emit(bloc.state.copyWith(isProfileLoading: false));
      },
      expect:
          () => [
            const HomeState(selectedIndex: 0, isProfileLoading: true),
            const HomeState(selectedIndex: 0, isProfileLoading: false),
          ],
    );

    test('state properties are correctly updated', () {
      // Test initial state
      expect(homeViewModel.state.selectedIndex, 0);
      expect(homeViewModel.state.user, null);
      expect(homeViewModel.state.isProfileLoading, false);

      // Test tab selection
      homeViewModel.onTabTapped(2);
      expect(homeViewModel.state.selectedIndex, 2);

      // Test user update
      final user = UserEntity(
        userId: '1',
        fname: 'Jane',
        lname: 'Smith',
        email: 'jane@example.com',
        phone: '0987654321',
        password: 'password456',
      );
      homeViewModel.emit(homeViewModel.state.copyWith(user: user));
      expect(homeViewModel.state.user, user);

      // Test loading state
      homeViewModel.emit(homeViewModel.state.copyWith(isProfileLoading: true));
      expect(homeViewModel.state.isProfileLoading, true);
    });
  });
}
