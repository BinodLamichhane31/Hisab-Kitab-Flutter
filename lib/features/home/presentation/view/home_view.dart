import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/features/customers/presentation/view/customers_page_view.dart';
import 'package:hisab_kitab/features/dashboard/presentation/view/dashboard_view.dart';
import 'package:hisab_kitab/features/home/presentation/view/bottom_view/more_view.dart';
import 'package:hisab_kitab/features/shops/presentation/view/widget/shop_switcher.dart';
import 'package:hisab_kitab/features/home/presentation/view_model/home_state.dart';
import 'package:hisab_kitab/features/home/presentation/view_model/home_view_model.dart';
import 'package:hisab_kitab/features/products/presentation/view/products_page_view.dart';
import 'package:hisab_kitab/features/suppliers/presentation/view/suppliers_page_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final List<Widget> viewsList = [
      const DashboardView(),
      const CustomersPageView(),
      const SuppliersPageView(),
      const ProductsPageView(),
      const MoreView(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: ShopSwitcherWidget(),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none),
              style: IconButton.styleFrom(
                backgroundColor: Colors.orange.withOpacity(0.2),
                foregroundColor: Colors.orange,
              ),
            ),
          ),
        ],
        elevation: 1,
      ),
      body: BlocBuilder<HomeViewModel, HomeState>(
        builder: (context, state) {
          return viewsList.elementAt(state.selectedIndex);
        },
      ),
      bottomNavigationBar: BlocBuilder<HomeViewModel, HomeState>(
        builder: (context, state) {
          return BottomNavigationBar(
            currentIndex: state.selectedIndex,
            selectedItemColor: Colors.orange,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            onTap: (newIndex) {
              context.read<HomeViewModel>().onTabTapped(newIndex);
            },
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_alt_outlined),
                label: 'Customers',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.fire_truck_outlined),
                label: 'Suppliers',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.inventory_outlined),
                label: 'Products',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_outlined),
                label: 'More',
              ),
            ],
          );
        },
      ),
    );
  }
}
