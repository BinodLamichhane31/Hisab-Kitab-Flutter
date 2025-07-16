import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/core/common/snackbar/my_snackbar.dart';
import 'package:hisab_kitab/core/session/session_cubit.dart';
import 'package:hisab_kitab/core/session/session_state.dart';
import 'package:hisab_kitab/features/shops/domain/entity/shop_entity.dart';
import 'package:hisab_kitab/features/shops/presentation/view/widget/add_shop_form.dart';
import 'package:hisab_kitab/features/shops/presentation/view_model/shop_state.dart';
import 'package:hisab_kitab/features/shops/presentation/view_model/shop_view_model.dart';

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

        if (state.shops.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GestureDetector(
            onTap:
                () => _showShopSwitcherBottomSheet(
                  context,
                  state.shops,
                  state.activeShop,
                ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              height: 35,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: Colors.orange),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.activeShop?.shopName ?? 'Select Shop',
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

  void _showAddShopDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final shopNameController = TextEditingController();
    final addressController = TextEditingController();
    final contactController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        // Wrap the dialog's content with a BlocListener to handle side effects.
        return BlocListener<ShopViewModel, ShopState>(
          listener: (context, state) {
            // On successful creation...
            if (state.shopCreationSuccess) {
              // 1. Show success snackbar
              if (state.successMessage != null) {
                showMySnackBar(
                  context: context,
                  message: state.successMessage!,
                );
              }
              // 2. Update the SessionCubit with the fresh list of shops
              context.read<SessionCubit>().onShopsUpdated(state.shops);
              // 3. Close the dialog
              Navigator.of(dialogContext).pop();
            }
            // On error...
            else if (state.errorMessage != null) {
              // Show error snackbar
              showMySnackBar(
                context: context,
                message: state.errorMessage!,
                color: Colors.red,
              );
            }
          },
          child: BlocBuilder<ShopViewModel, ShopState>(
            builder: (context, state) {
              // The AlertDialog now only builds the UI, side effects are in the listener.
              return AlertDialog(
                title: const Text('Add a New Shop'),
                content: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: addShopForm(
                      context: context,
                      shopNameController: shopNameController,
                      addressController: addressController,
                      contactController: contactController,
                      state: state,
                      formKey: formKey,
                      submitButtonText: 'Add Shop',
                      isDialog: true,
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.of(dialogContext).pop(),
                  ),
                ],
              );
            },
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
      isScrollControlled: false, // As per your request
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (bottomSheetContext) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Switch Shop',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 10),

              /// Scrollable shop list
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 300, // 👈 Limit height so list becomes scrollable
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: shops.length,
                  itemBuilder: (context, index) {
                    final shop = shops[index];
                    return ListTile(
                      leading: Icon(
                        shop == activeShop
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color:
                            shop == activeShop ? Colors.orange : Colors.white70,
                      ),
                      title: Text(
                        shop.shopName,
                        style: TextStyle(
                          color:
                              shop == activeShop ? Colors.orange : Colors.white,
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
                        Navigator.pop(bottomSheetContext);
                      },
                    );
                  },
                ),
              ),

              const Divider(),
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
                  Navigator.pop(bottomSheetContext);
                  _showAddShopDialog(context);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
