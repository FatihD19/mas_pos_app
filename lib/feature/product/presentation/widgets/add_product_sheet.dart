import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mas_pos_app/commons/theme.dart';
import 'package:mas_pos_app/feature/category/presentation/bloc/category_bloc.dart';
import 'package:mas_pos_app/feature/category/data/models/category_response_model.dart';
import 'package:mas_pos_app/feature/product/presentation/bloc/product/product_bloc.dart';
import 'package:mas_pos_app/feature/product/data/model/product_request_model.dart';
import 'package:mas_pos_app/utils/utils.dart';

class AddProductSheet extends StatefulWidget {
  const AddProductSheet({super.key});

  @override
  State<AddProductSheet> createState() => _AddProductSheetState();
}

class _AddProductSheetState extends State<AddProductSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();

  CategoryModel? _selectedCategory;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Load categories when modal opens
    context.read<CategoryBloc>().add(GetCategoriesEvent());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  void _addProduct() {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      final request = AddProductRequestModel(
        categoryId: _selectedCategory!.id!,
        name: _nameController.text.trim(),
        price:
            int.parse(_priceController.text.replaceAll(RegExp(r'[^0-9]'), '')),
        picturePath: _selectedImage?.path,
      );

      context.read<ProductBloc>().add(AddProductEvent(request));
    } else if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih kategori'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 50,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Tambah Produk',
              style: primaryTextStyle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Expanded(
            child: BlocListener<ProductBloc, ProductState>(
              listener: (context, state) {
                if (state is ProductAdded) {
                  Navigator.pop(
                      context, true); // Return true untuk indicate success
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Produk berhasil ditambahkan'),
                      backgroundColor: primaryColor,
                    ),
                  );
                } else if (state is ProductError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Upload Section
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey[50],
                          ),
                          child: _selectedImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    _selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.cloud_upload_outlined,
                                      size: 48,
                                      color: primaryColor,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Seret & Letakkan atau Pilih File untuk diunggah',
                                      style: secondaryTextStyle.copyWith(
                                          fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Format Yang Didukung: Jpg & Png\nUkuran File Maksimum 5Mb',
                                      style: secondaryTextStyle.copyWith(
                                        fontSize: 12,
                                        color: Colors.grey[500],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                        ),
                      ),

                      // if (_selectedImage != null)
                      //   Padding(
                      //     padding: const EdgeInsets.only(top: 8),
                      //     child: Text(
                      //       'Filemu Terlalu Besar, Melebihi 5 Mb',
                      //       style: primaryTextStyle.copyWith(
                      //         fontSize: 12,
                      //         color: Colors.red,
                      //       ),
                      //     ),
                      //   ),

                      const SizedBox(height: 24),

                      // Product Name Field
                      Text(
                        'Nama Produk',
                        style: primaryTextStyle.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'Masukkan nama produk',
                          hintStyle: secondaryTextStyle.copyWith(fontSize: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama produk tidak boleh kosong';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Price Field
                      Text(
                        'Harga',
                        style: primaryTextStyle.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Rp 0',
                          hintStyle: secondaryTextStyle.copyWith(fontSize: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        inputFormatters: [
                          // Import: import 'package:flutter/services.dart';
                          FilteringTextInputFormatter.digitsOnly,
                          TextInputFormatter.withFunction((oldValue, newValue) {
                            String newText = newValue.text.replaceAll('.', '');
                            if (newText.isEmpty)
                              return newValue.copyWith(text: '');
                            int value = int.parse(newText);
                            String formatted =
                                '${RupiahFormatter.format(value)}';
                            return TextEditingValue(
                              text: formatted,
                              selection: TextSelection.collapsed(
                                  offset: formatted.length),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          // Remove 'Rp ' and dots for controller value
                          String digits =
                              value.replaceAll(RegExp(r'[^0-9]'), '');
                          _priceController.value = TextEditingValue(
                            text: value,
                            selection:
                                TextSelection.collapsed(offset: value.length),
                          );
                        },
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Harga tidak boleh kosong';
                          }
                          String digits =
                              value.replaceAll(RegExp(r'[^0-9]'), '');
                          if (digits.isEmpty ||
                              int.tryParse(digits) == null ||
                              int.parse(digits) <= 0) {
                            return 'Harga harus berupa angka yang valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Category Dropdown
                      Text(
                        'Pilih Kategori',
                        style: primaryTextStyle.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      BlocBuilder<CategoryBloc, CategoryState>(
                        builder: (context, state) {
                          if (state is CategoryLoading) {
                            return Container(
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                            );
                          }

                          if (state is CategoryLoaded &&
                              state.category.data != null) {
                            return DropdownButtonFormField<CategoryModel>(
                              value: _selectedCategory,
                              hint: Text(
                                'Pilih kategori',
                                style:
                                    secondaryTextStyle.copyWith(fontSize: 14),
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: Colors.grey[300]!),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: Colors.grey[300]!),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: primaryColor),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                              items: state.category.data!
                                  .map((category) =>
                                      DropdownMenuItem<CategoryModel>(
                                        value: category,
                                        child: Text(
                                          category.name ?? '',
                                          style: primaryTextStyle.copyWith(
                                              fontSize: 14),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedCategory = value;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Silakan pilih kategori';
                                }
                                return null;
                              },
                            );
                          }

                          if (state is CategoryError) {
                            return Container(
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.red[300]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  'Error loading categories',
                                  style: primaryTextStyle.copyWith(
                                    fontSize: 14,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            );
                          }

                          return Container(
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                'No categories available',
                                style:
                                    secondaryTextStyle.copyWith(fontSize: 14),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 32),
                      BlocBuilder<ProductBloc, ProductState>(
                        builder: (context, state) {
                          if (state is ProductLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is ProductAdded) {
                            return Text(
                              'Produk berhasil ditambahkan',
                              style: primaryTextStyle.copyWith(
                                color: primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          } else if (state is ProductError) {
                            return Text(
                              'Gagal menambahkan produk: ${state.message}',
                              style: primaryTextStyle.copyWith(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            );
                          }
                          return Container();
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Bottom Buttons
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                final isLoading = state is ProductLoading;

                return Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed:
                            isLoading ? null : () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: primaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Batal',
                          style: primaryTextStyle.copyWith(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _addProduct,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Text(
                                'Tambah',
                                style: buttonTextStyle.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
