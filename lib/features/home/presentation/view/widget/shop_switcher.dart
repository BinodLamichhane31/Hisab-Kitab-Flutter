import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/core/session/session_cubit.dart';
import 'package:hisab_kitab/core/session/session_state.dart';
import 'package:hisab_kitab/features/shops/domain/entity/shop_entity.dart';

class ShopSwitcherWidget extends StatelessWidget {
  const ShopSwitcherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // This widget listens to the global SessionCubit for state changes.
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) {
        // Show a loading indicator while the shop is being switched.
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

        // If the user has 1 or 0 shops, there's no need to show a switcher.
        if (state.shops.length <= 1) {
          return const SizedBox.shrink();
        }

        // Build the dropdown button for switching shops.
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<ShopEntity>(
              value: state.activeShop,
              icon: const Icon(Icons.swap_horiz, color: Colors.white),
              dropdownColor: Theme.of(context).appBarTheme.backgroundColor,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              onChanged: (ShopEntity? newShop) {
                if (newShop != null) {
                  // Dispatch the event to the SessionCubit to switch the shop.
                  context.read<SessionCubit>().switchShop(newShop);
                }
              },
              items:
                  state.shops.map<DropdownMenuItem<ShopEntity>>((shop) {
                    return DropdownMenuItem<ShopEntity>(
                      value: shop,
                      child: Text(shop.shopName),
                    );
                  }).toList(),
            ),
          ),
        );
      },
    );
  }
}
