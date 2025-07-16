import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/features/shops/presentation/view_model/shop_event.dart';
import 'package:hisab_kitab/features/shops/presentation/view_model/shop_state.dart';
import 'package:hisab_kitab/features/shops/presentation/view_model/shop_view_model.dart';

Column addShopForm({
  required BuildContext context,
  required TextEditingController shopNameController,
  required TextEditingController addressController,
  required TextEditingController contactController,
  required ShopState state,
  required GlobalKey<FormState> formKey,
  required String submitButtonText,
  bool isDialog = false,
}) {
  final orangeThemeColor = Colors.orange.shade700;
  final textTheme = Theme.of(context).textTheme;

  final inputDecoration = InputDecoration(
    labelStyle: TextStyle(color: orangeThemeColor),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade400),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: orangeThemeColor, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
    prefixIconColor: orangeThemeColor,
  );

  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min, // Important for use in dialogs
    children: [
      if (!isDialog) ...[
        Text(
          'Welcome!',
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: orangeThemeColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Let\'s get your business on board.',
          style: textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
      ],
      TextFormField(
        controller: shopNameController,
        decoration: inputDecoration.copyWith(
          labelText: 'Shop Name',
          prefixIcon: const Icon(Icons.storefront_outlined),
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
        decoration: inputDecoration.copyWith(
          labelText: 'Address',
          prefixIcon: const Icon(Icons.location_city),
        ),
        validator:
            (value) =>
                (value?.trim().isEmpty ?? true) ? 'Address is required' : null,
      ),
      const SizedBox(height: 24),
      TextFormField(
        controller: contactController,
        decoration: inputDecoration.copyWith(
          labelText: 'Contact Number',
          prefixIcon: const Icon(Icons.phone),
        ),
        keyboardType: TextInputType.phone,
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
          style: ElevatedButton.styleFrom(
            backgroundColor: orangeThemeColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed:
              state.isLoading
                  ? null
                  : () {
                    if (formKey.currentState!.validate()) {
                      context.read<ShopViewModel>().add(
                        CreateShopEvent(
                          shopName: shopNameController.text.trim(),
                          address: addressController.text.trim(),
                          contactNumber: contactController.text.trim(),
                        ),
                      );
                    }
                  },
          child:
              state.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(submitButtonText),
        ),
      ),
    ],
  );
}
