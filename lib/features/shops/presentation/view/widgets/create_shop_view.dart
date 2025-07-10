import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/app/service_locator/service_locator.dart';
import 'package:hisab_kitab/core/common/snackbar/my_snackbar.dart';
import 'package:hisab_kitab/core/session/session_cubit.dart';
import 'package:hisab_kitab/features/home/presentation/view/home_view.dart';
import 'package:hisab_kitab/features/home/presentation/view_model/home_view_model.dart';
import 'package:hisab_kitab/features/shops/presentation/view_model/shop_event.dart';
import 'package:hisab_kitab/features/shops/presentation/view_model/shop_state.dart';
import 'package:hisab_kitab/features/shops/presentation/view_model/shop_view_model.dart';

class CreateShopView extends StatelessWidget {
  const CreateShopView({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Initialize controllers and keys inside the build method.
    // They will be re-created on each build, which is fine for this simple case.
    // For more complex forms, a stateful widget or a form library is better,
    // but for a single-field form, this is clean and efficient.
    final formKey = GlobalKey<FormState>();
    final shopNameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your First Shop'),
        automaticallyImplyLeading: false,
      ),
      // 2. Add a WillPopScope to prevent the user from backing out with the android back button
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

              // It's good practice to dispose of controllers when they are no longer needed.
              // shopNameController.dispose();

              context.read<ShopViewModel>().add(
                NavigateToHomeView(context: context, destination: HomeView()),
              );
            }
          },
          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  // 3. Use the formKey defined above
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
                        // 4. Use the controller defined above
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
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed:
                              state.isLoading
                                  ? null
                                  : () {
                                    // 5. Validate using the same formKey
                                    if (formKey.currentState!.validate()) {
                                      context.read<ShopViewModel>().add(
                                        CreateShopEvent(
                                          shopName:
                                              shopNameController.text.trim(),
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
              ),
            );
          },
        ),
      ),
    );
  }
}
