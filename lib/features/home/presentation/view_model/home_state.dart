import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/auth/domain/entity/user_entity.dart';

class HomeState extends Equatable {
  final int selectedIndex;
  final UserEntity? user;
  final bool isProfileLoading;

  const HomeState({
    required this.selectedIndex,
    this.user,
    this.isProfileLoading = false,
  });

  factory HomeState.initial() {
    return const HomeState(selectedIndex: 0);
  }

  HomeState copyWith({
    int? selectedIndex,
    UserEntity? user,
    bool? isProfileLoading,
  }) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      user: user ?? this.user,
      isProfileLoading: isProfileLoading ?? this.isProfileLoading,
    );
  }

  @override
  List<Object?> get props => [selectedIndex, user, isProfileLoading];
}
