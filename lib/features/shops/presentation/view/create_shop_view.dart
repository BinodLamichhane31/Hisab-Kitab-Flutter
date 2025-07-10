import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/core/common/snackbar/my_snackbar.dart';
import 'package:hisab_kitab/core/session/session_cubit.dart';
import 'package:hisab_kitab/features/home/presentation/view/home_view.dart';
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Welcome!',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Let\'s get your business on board.',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    TextFormField(
                      controller: shopNameController,
                      decoration: const InputDecoration(
                        labelText: 'Shop Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.storefront_outlined),
                      ),
                      validator:
                          (value) =>
                              (value?.trim().isEmpty ?? true)
                                  ? 'Shop name is required'
                                  : null,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_city),
                      ),
                      validator:
                          (value) =>
                              (value?.trim().isEmpty ?? true)
                                  ? 'Address is required'
                                  : null,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: contactController,
                      decoration: const InputDecoration(
                        labelText: 'Contact Number',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                      validator:
                          (value) =>
                              (value?.trim().isEmpty ?? true)
                                  ? 'Contact number is required'
                                  : null,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed:
                            state.isLoading
                                ? null
                                : () {
                                  if (formKey.currentState!.validate()) {
                                    context.read<ShopViewModel>().add(
                                      CreateShopEvent(
                                        shopName:
                                            shopNameController.text.trim(),
                                        address: addressController.text,
                                        contactNumber: contactController.text,
                                      ),
                                    );
                                  }
                                },
                        child:
                            state.isLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const Text('Create and Continue'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
