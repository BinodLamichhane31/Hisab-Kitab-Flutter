import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/core/common/snackbar/my_snackbar.dart';
import 'package:hisab_kitab/core/session/session_cubit.dart';
import 'package:hisab_kitab/features/home/presentation/view/home_view.dart';
import 'package:hisab_kitab/features/shops/presentation/view/widget/add_shop_form.dart';
import 'package:hisab_kitab/features/shops/presentation/view_model/shop_event.dart';
import 'package:hisab_kitab/features/shops/presentation/view_model/shop_state.dart';
import 'package:hisab_kitab/features/shops/presentation/view_model/shop_view_model.dart';

class CreateShopView extends StatelessWidget {
  const CreateShopView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final shopNameController = TextEditingController();
    final addressController = TextEditingController();
    final contactController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your First Shop'),
        automaticallyImplyLeading: false,
      ),
      body: WillPopScope(
        onWillPop: () async => false,
        child: BlocConsumer<ShopViewModel, ShopState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              showMySnackBar(
                context: context,
                message: state.errorMessage!,
                color: Colors.red,
              );
            }
            if (state.shops != null && state.shops!.isNotEmpty) {
              final sessionCubit = context.read<SessionCubit>();
              final allShops = state.shops!;
              final newShop = allShops.first;

              sessionCubit.onLoginSuccess(
                user: sessionCubit.state.user!,
                shops: allShops,
                activeShop: newShop,
              );

              context.read<ShopViewModel>().add(
                NavigateToHomeView(context: context, destination: HomeView()),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: formKey,
                child: addShopForm(
                  context: context,
                  shopNameController: shopNameController,
                  addressController: addressController,
                  contactController: contactController,
                  state: state,
                  formKey: formKey,
                  submitButtonText: "Create and Continue",
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
