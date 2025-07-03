import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:hisab_kitab/features/auth/domain/entity/user_entity.dart';
import 'package:hisab_kitab/features/customers/presentation/view/customers_page_view.dart';
import 'package:hisab_kitab/features/home/presentation/view/bottom_view/dashboard_view.dart';
import 'package:hisab_kitab/features/home/presentation/view/bottom_view/profile_page_view.dart';
import 'package:hisab_kitab/features/products/presentation/view/products_page_view.dart';
import 'package:hisab_kitab/features/suppliers/presentation/view/suppliers_page_view.dart';

class HomeState extends Equatable {
  final int selectedIndex;
  final List<Widget> viewsList;
  final List<String> titleList;
  final UserEntity? user;
  final bool isProfileLoading;

  const HomeState({
    required this.selectedIndex,
    required this.viewsList,
    required this.titleList,
    this.user,
    this.isProfileLoading = false,
  });

  static HomeState initial() {
    return HomeState(
      selectedIndex: 0,
      viewsList: [
        DashboardView(),
        CustomersPageView(),
        SuppliersPageView(),
        ProductsPageView(),
        ProfilePageView(),
      ],
      titleList: ["Home", "Customers", "Suppliers", "Products", "Profile"],
    );
  }

  HomeState copyWith({
    int? selectedIndex,
    List<Widget>? viewsList,
    List<String>? titleList,
    UserEntity? user,
    bool? isProfileLoading,
  }) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      viewsList: this.viewsList,
      titleList: this.titleList,
      user: user ?? this.user,
      isProfileLoading: isProfileLoading ?? this.isProfileLoading,
    );
  }

  @override
  List<Object?> get props => [selectedIndex, user, isProfileLoading];
}
