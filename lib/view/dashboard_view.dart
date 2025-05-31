import 'package:flutter/material.dart';
import 'package:hisab_kitab/view/dashboard_screens/customers_page_view.dart';
import 'package:hisab_kitab/view/dashboard_screens/home_page_view.dart';
import 'package:hisab_kitab/view/dashboard_screens/products_page_view.dart';
import 'package:hisab_kitab/view/dashboard_screens/profile_page_view.dart';
import 'package:hisab_kitab/view/dashboard_screens/suppliers_page_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePageView(),
    CustomersPageView(),
    SuppliersPageView(),
    ProductsPageView(),
    ProfilePageView(),
  ];

  final List<Widget> _drawerPages = const [
    HomePageView(),
    CustomersPageView(),
    SuppliersPageView(),
    ProductsPageView(),
    ProfilePageView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        title: Text("Home"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none, size: 16),
              style: IconButton.styleFrom(backgroundColor: Colors.orange),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.only(top: 20),
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  Image.asset(
                    isDark
                        ? 'assets/logo/app_logo_white.png'
                        : 'assets/logo/app_logo_black.png',
                    height: 30,
                  ),
                  SizedBox(height: 20),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(
                        'assets/images/profile_image.png',
                      ),
                    ),
                    title: Text(
                      "Binod Lamichhane",
                      style: TextStyle(fontSize: 16),
                    ),
                    subtitle: Text(
                      "lamichhanebinod@gmail.com",
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('Manage Shops', style: TextStyle(fontSize: 14)),
              selected: _selectedIndex == 0,
              onTap: () {
                // Update the state of the app
                _onItemTapped(0);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Sales', style: TextStyle(fontSize: 14)),
              selected: _selectedIndex == 1,
              onTap: () {
                // Update the state of the app
                _onItemTapped(0);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Purchase', style: TextStyle(fontSize: 14)),
              selected: _selectedIndex == 2,
              onTap: () {
                // Update the state of the app
                _onItemTapped(0);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Reports', style: TextStyle(fontSize: 14)),
              selected: _selectedIndex == 3,
              onTap: () {
                // Update the state of the app
                _onItemTapped(0);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Settings', style: TextStyle(fontSize: 14)),
              selected: _selectedIndex == 4,
              onTap: () {
                // Update the state of the app
                _onItemTapped(0);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                'Help and Support',
                style: TextStyle(fontSize: 14),
              ),
              selected: _selectedIndex == 5,
              onTap: () {
                // Update the state of the app
                _onItemTapped(0);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                'Privacy Policy',
                style: TextStyle(fontSize: 14),
              ),
              selected: _selectedIndex == 6,
              onTap: () {
                // Update the state of the app
                _onItemTapped(0);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (newIndex) => setState(() => _selectedIndex = newIndex),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Customers'),
          BottomNavigationBarItem(
            icon: Icon(Icons.fire_truck),
            label: 'Suppliers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Products',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
