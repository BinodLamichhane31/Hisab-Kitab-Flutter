import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:badges/badges.dart' as badges;
import 'package:hisab_kitab/features/customers/presentation/view/customers_page_view.dart';
import 'package:hisab_kitab/features/dashboard/presentation/view/dashboard_view.dart';
import 'package:hisab_kitab/features/home/presentation/view/bottom_view/more_view.dart';
import 'package:hisab_kitab/features/notification/presentation/view/notification_view.dart';
import 'package:hisab_kitab/features/notification/presentation/view_model/notification_state.dart';
import 'package:hisab_kitab/features/notification/presentation/view_model/notification_view_model.dart';
import 'package:hisab_kitab/features/shops/presentation/view/widget/shop_switcher.dart';
import 'package:hisab_kitab/features/home/presentation/view_model/home_state.dart';
import 'package:hisab_kitab/features/home/presentation/view_model/home_view_model.dart';
import 'package:hisab_kitab/features/products/presentation/view/products_page_view.dart';
import 'package:hisab_kitab/features/suppliers/presentation/view/suppliers_page_view.dart';
import 'package:hisab_kitab/core/services/shop_switch_service.dart';
import 'package:hisab_kitab/core/services/gyroscope_transaction_service.dart';
import 'package:hisab_kitab/app/service_locator/service_locator.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late ShopSwitchService _shopSwitchService;
  late GyroscopeTransactionService _gyroscopeTransactionService;
  bool _shakeDetectionInitialized = false;
  bool _gyroscopeTransactionInitialized = false;

  @override
  void initState() {
    super.initState();
    _shopSwitchService = serviceLocator<ShopSwitchService>();
    _gyroscopeTransactionService =
        serviceLocator<GyroscopeTransactionService>();
    // Start listening for shake events when the home view is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_shopSwitchService.isSupported) {
        await _shopSwitchService.startListening(context);
        setState(() {
          _shakeDetectionInitialized = true;
        });
      } else {
        print('Shake detection not supported on this platform');
      }

      // Start listening for gyroscope events for transaction navigation
      if (_gyroscopeTransactionService.isSupported) {
        await _gyroscopeTransactionService.startListening(context);
        setState(() {
          _gyroscopeTransactionInitialized = true;
        });
      } else {
        print('Gyroscope transaction service not supported on this platform');
      }
    });
  }

  @override
  void dispose() {
    _shopSwitchService.stopListening();
    _gyroscopeTransactionService.stopListening();
    super.dispose();
  }

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
            child: BlocBuilder<NotificationViewModel, NotificationState>(
              builder: (context, state) {
                return badges.Badge(
                  position: badges.BadgePosition.topEnd(top: 0, end: 3),
                  showBadge: state.unreadCount > 0,
                  badgeContent: Text(
                    state.unreadCount.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationView(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.notifications_none),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.orange.withOpacity(0.2),
                      foregroundColor: Colors.orange,
                    ),
                  ),
                );
              },
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
