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

        if (state.shops.length <= 1) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor, // Matches theme
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(color: Colors.orange),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<ShopEntity>(
                value: state.activeShop,
                icon: const Icon(
                  Icons.arrow_drop_down_outlined,
                  color: Colors.white,
                ),
                dropdownColor: Theme.of(context).appBarTheme.backgroundColor,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                onChanged: (ShopEntity? newShop) {
                  if (newShop != null) {
                    context.read<SessionCubit>().switchShop(
                      newShop,
                      context,
                      newShop.shopName,
                    );
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
          ),
        );
      },
    );
  }
}
