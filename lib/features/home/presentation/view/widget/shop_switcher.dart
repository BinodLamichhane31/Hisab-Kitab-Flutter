import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/core/session/session_cubit.dart';
import 'package:hisab_kitab/core/session/session_state.dart';
import 'package:hisab_kitab/features/shops/domain/entity/shop_entity.dart';

class ShopSwitcherWidget extends StatelessWidget {
  const ShopSwitcherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
          );
        }

        // Show the widget if there's at least one shop
        if (state.shops.isEmpty) {
          return const SizedBox.shrink(); // Hide if no shops exist
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GestureDetector(
            onTap: () {
              _showShopSwitcherBottomSheet(
                context,
                state.shops,
                state.activeShop,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              height: 35,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor, // Matches theme
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: Colors.orange),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.activeShop?.shopName ??
                        'Select Shop', // Display active shop name
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const Icon(
                    Icons.arrow_drop_down_outlined,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showShopSwitcherBottomSheet(
    BuildContext context,
    List<ShopEntity> shops,
    ShopEntity? activeShop,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          decoration: BoxDecoration(
            color:
                Theme.of(
                  context,
                ).appBarTheme.backgroundColor, // Background color for the sheet
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Switch Shop',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
              ),
              // List existing shops
              ...shops.map(
                (shop) => ListTile(
                  leading: Icon(
                    shop == activeShop
                        ? Icons.check_circle
                        : Icons.circle_outlined,
                    color: shop == activeShop ? Colors.orange : Colors.white70,
                  ),
                  title: Text(
                    shop.shopName,
                    style: TextStyle(
                      color: shop == activeShop ? Colors.orange : Colors.white,
                      fontWeight:
                          shop == activeShop
                              ? FontWeight.bold
                              : FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    if (shop != activeShop) {
                      context.read<SessionCubit>().switchShop(
                        shop,
                        context,
                        shop.shopName,
                      );
                    }
                    Navigator.pop(bc); // Close bottom sheet
                  },
                ),
              ),
              // Add New Shop option
              ListTile(
                leading: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.greenAccent,
                ),
                title: const Text(
                  'Add New Shop',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(bc); // Close bottom sheet
                  // TODO: Navigate to the "Add New Shop" screen
                  // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewShopScreen()));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Navigate to Add New Shop screen'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        );
      },
    );
  }
}
