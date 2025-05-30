import 'package:flutter/material.dart';
import 'package:hisab_kitab/view/dashboard_screens/customers_page_view.dart';
import 'package:hisab_kitab/view/dashboard_screens/home_page_view.dart';
import 'package:hisab_kitab/view/dashboard_screens/products_page_view.dart';
import 'package:hisab_kitab/view/dashboard_screens/profile_page_view.dart';
import 'package:hisab_kitab/view/dashboard_screens/suppliers_page_view.dart';

class DashboardView extends StatelessWidget {
  DashboardView({super.key});

  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);

  final List<StatelessWidget> _pages = const [
    HomePageView(),
    CustomersPageView(),
    SuppliersPageView(),
    ProductsPageView(),
    ProfilePageView(),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _selectedIndex,
      builder: (context, index, _) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            toolbarHeight: 70,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.menu),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Business Name",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down),
                    ],
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.orange,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Icons.notifications_none, size: 18),
                ),
              ],
            ),
          ),
          body: _pages[index],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: index,
            selectedItemColor: Colors.orange,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            onTap: (newIndex) => _selectedIndex.value = newIndex,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: 'Customers',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.fire_truck),
                label: 'Suppliers',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.inventory),
                label: 'Products',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
