import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hisab_kitab/core/session/session_cubit.dart';
import 'package:hisab_kitab/core/session/session_state.dart';
import 'package:hisab_kitab/features/customers/presentation/view/customers_page_view.dart';
import 'package:hisab_kitab/features/home/presentation/view/bottom_view/dashboard_view.dart';
import 'package:hisab_kitab/features/home/presentation/view/bottom_view/profile_page_view.dart';
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
      const ProfilePageView(),
    ];
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
        // CHANGE: The AppBar title now shows the active shop name from SessionCubit
        title: ShopSwitcherWidget(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_none,
              ), // Increased size slightly for better visibility
              style: IconButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.only(top: 20),
          children: [
            // CHANGE: The DrawerHeader now gets user info from SessionCubit
            BlocBuilder<SessionCubit, SessionState>(
              builder: (context, sessionState) {
                return DrawerHeader(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        isDark
                            ? 'assets/logo/app_logo_white.png'
                            : 'assets/logo/app_logo_black.png',
                        height: 30,
                      ),
                      const SizedBox(height: 20),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const CircleAvatar(
                          backgroundImage: AssetImage(
                            'assets/images/profile_image.png',
                          ),
                        ),
                        title: Text(
                          // Get user name from the global session
                          "${sessionState.user?.fname ?? ''} ${sessionState.user?.lname ?? ''}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        subtitle: Text(
                          // Get user email from the global session
                          sessionState.user?.email ?? 'No email',
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.shop_2),
              title: const Text('Manage Shops', style: TextStyle(fontSize: 14)),
              onTap: () {
                // TODO: Navigate to a screen to manage all shops (add, edit, delete)
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.sackDollar),
              title: const Text('Sales', style: TextStyle(fontSize: 14)),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.money_off),
              title: const Text('Purchase', style: TextStyle(fontSize: 14)),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.report_sharp),
              title: const Text('Reports', style: TextStyle(fontSize: 14)),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings', style: TextStyle(fontSize: 14)),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text(
                'Help and Support',
                style: TextStyle(fontSize: 14),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text(
                'Privacy Policy',
                style: TextStyle(fontSize: 14),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text(
                'Logout',
                style: TextStyle(fontSize: 14, color: Colors.redAccent),
              ),
              onTap: () {
                context.read<HomeViewModel>().logout(context);
              },
            ),
          ],
        ),
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
                icon: Icon(Icons.person_outlined),
                label: 'Profile',
              ),
            ],
          );
        },
      ),
    );
  }
}
