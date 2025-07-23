import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/app/constant/api_endpoints.dart';
import 'package:hisab_kitab/app/service_locator/service_locator.dart';
import 'package:hisab_kitab/features/products/domain/entity/product_entity.dart';
import 'package:hisab_kitab/features/products/domain/use_case/add_product_usecase.dart';
import 'package:hisab_kitab/features/products/domain/use_case/update_product_usecase.dart';
import 'package:hisab_kitab/features/products/presentation/view_model/product_form_event.dart';
import 'package:hisab_kitab/features/products/presentation/view_model/product_form_state.dart';
import 'package:hisab_kitab/features/products/presentation/view_model/product_form_view_model.dart';
import 'package:image_picker/image_picker.dart';

const List<String> _productCategories = [
  'Groceries & Food',
  'Beverages',
  'Electronics & Gadgets',
  'Fashion & Apparel',
  'Health & Personal Care',
  'Home & Kitchen',
  'Furniture & Decor',
  'Books & Stationery',
  'Sports & Outdoors',
  'Toys & Games',
  'Automotive & Tools',
  'Pet Supplies',
  'Beauty & Cosmetics',
  'Office Supplies',
  'Other',
];

class ProductFormPage extends StatelessWidget {
  final String shopId;
  final ProductEntity? productToEdit;

  const ProductFormPage({super.key, required this.shopId, this.productToEdit});

  bool get isEditing => productToEdit != null;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => ProductFormViewModel(
            addProductUsecase: serviceLocator<AddProductUsecase>(),
            updateProductUsecase: serviceLocator<UpdateProductUsecase>(),
          ),
      child: BlocListener<ProductFormViewModel, ProductFormState>(
        listener: (context, state) {
          if (state.status == ProductFormStatus.success) {
            final message =
                isEditing
                    ? 'Product updated successfully.'
                    : 'Product added successfully.';
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(message), backgroundColor: Colors.green),
              );
            Navigator.of(context).pop(true); // Return true to signal refresh
          } else if (state.status == ProductFormStatus.error) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    state.errorMessage ?? 'An unknown error occurred.',
                  ),
                  backgroundColor: Colors.red,
                ),
              );
          }
        },
        child: _ProductFormView(shopId: shopId, productToEdit: productToEdit),
      ),
    );
  }
}

class _ProductFormView extends StatefulWidget {
  final String shopId;
  final ProductEntity? productToEdit;

  const _ProductFormView({required this.shopId, this.productToEdit});

  bool get isEditing => productToEdit != null;

  @override
  State<_ProductFormView> createState() => _ProductFormViewState();
}

class _ProductFormViewState extends State<_ProductFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _reorderLevelController = TextEditingController();

  String? _selectedCategory;
  File? _selectedImageFile;
  String? _existingImageUrl;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      final product = widget.productToEdit!;
      _nameController.text = product.name;
      _sellingPriceController.text = product.sellingPrice.toString();
      _purchasePriceController.text = product.purchasePrice.toString();
      _quantityController.text = product.quantity.toString();
      _descriptionController.text = product.description;
      _reorderLevelController.text = product.reorderLevel.toString();
      _selectedCategory = product.category;
      _existingImageUrl = product.image;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sellingPriceController.dispose();
    _purchasePriceController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    _reorderLevelController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImageFile = File(pickedFile.path);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<ProductFormViewModel>().add(
        SubmitProductFormEvent(
          productId: widget.productToEdit?.productId,
          shopId: widget.shopId,
          name: _nameController.text,
          sellingPrice: double.parse(_sellingPriceController.text),
          purchasePrice: double.parse(_purchasePriceController.text),
          quantity: int.parse(_quantityController.text),
          category: _selectedCategory!,
          description: _descriptionController.text,
          reorderLevel: int.parse(_reorderLevelController.text),
          imageFile: _selectedImageFile,
          existingImageUrl: _existingImageUrl,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Product' : 'Add New Product'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImagePicker(),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  labelStyle: TextStyle(color: Colors.grey[400]),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Colors.orange.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Colors.orange,
                      width: 2.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Colors.redAccent,
                      width: 2.0,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Colors.redAccent,
                      width: 2.5,
                    ),
                  ),
                  errorStyle: const TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  labelStyle: TextStyle(color: Colors.grey[400]),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Colors.orange.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Colors.orange,
                      width: 2.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Colors.redAccent,
                      width: 2.0,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Colors.redAccent,
                      width: 2.5,
                    ),
                  ),
                  errorStyle: const TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                items:
                    _productCategories
                        .map(
                          (cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)),
                        )
                        .toList(),
                onChanged: (value) => setState(() => _selectedCategory = value),
                validator:
                    (value) =>
                        value == null ? 'Please select a category' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _sellingPriceController,
                      decoration: InputDecoration(
                        labelText: 'Selling Price',
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        labelStyle: TextStyle(color: Colors.grey[400]),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: Colors.orange.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Colors.orange,
                            width: 2.0,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Colors.redAccent,
                            width: 2.0,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Colors.redAccent,
                            width: 2.5,
                          ),
                        ),
                        errorStyle: const TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator:
                          (value) =>
                              value!.isEmpty || double.tryParse(value) == null
                                  ? 'Enter a valid price'
                                  : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _purchasePriceController,
                      decoration: InputDecoration(
                        labelText: 'Purchase Price',
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        labelStyle: TextStyle(color: Colors.grey[400]),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: Colors.orange.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Colors.orange,
                            width: 2.0,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Colors.redAccent,
                            width: 2.0,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Colors.redAccent,
                            width: 2.5,
                          ),
                        ),
                        errorStyle: const TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator:
                          (value) =>
                              value!.isEmpty || double.tryParse(value) == null
                                  ? 'Enter a valid price'
                                  : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _reorderLevelController,
                decoration: InputDecoration(
                  labelText: 'Re-order Level',
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  labelStyle: TextStyle(color: Colors.grey[400]),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Colors.orange.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Colors.orange,
                      width: 2.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Colors.redAccent,
                      width: 2.0,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Colors.redAccent,
                      width: 2.5,
                    ),
                  ),
                  errorStyle: const TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description (Optional)',
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  labelStyle: TextStyle(color: Colors.grey[400]),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Colors.orange.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Colors.orange,
                      width: 2.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Colors.redAccent,
                      width: 2.0,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Colors.redAccent,
                      width: 2.5,
                    ),
                  ),
                  errorStyle: const TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                maxLines: 3,
              ),

              const SizedBox(height: 30),
              BlocBuilder<ProductFormViewModel, ProductFormState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed:
                        state.status == ProductFormStatus.loading
                            ? null
                            : _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child:
                        state.status == ProductFormStatus.loading
                            ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Colors.white,
                              ),
                            )
                            : Text(
                              widget.isEditing
                                  ? 'Update Product'
                                  : 'Save Product',
                              style: TextStyle(color: Colors.grey[300]),
                            ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    Widget imageWidget;
    if (_selectedImageFile != null) {
      imageWidget = Image.file(_selectedImageFile!, fit: BoxFit.cover);
    } else if (_existingImageUrl != null) {
      imageWidget = Image.network(
        '${ApiEndpoints.serverAddress}${_existingImageUrl!}',
        fit: BoxFit.cover,
        errorBuilder:
            (context, error, stackTrace) =>
                const Icon(Icons.broken_image, size: 40, color: Colors.grey),
      );
    } else {
      imageWidget = const Icon(
        Icons.add_a_photo_outlined,
        size: 40,
        color: Colors.grey,
      );
    }

    return Center(
      child: GestureDetector(
        onTap: _pickImage,
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: imageWidget,
          ),
        ),
      ),
    );
  }
}
