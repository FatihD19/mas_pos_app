import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mas_pos_app/commons/theme.dart';
import 'package:mas_pos_app/feature/category/presentation/bloc/category_bloc.dart';
import 'package:mas_pos_app/feature/category/data/models/category_request_model.dart';

class AddCategorySheet extends StatefulWidget {
  const AddCategorySheet({super.key});

  @override
  State<AddCategorySheet> createState() => _AddCategorySheetState();
}

class _AddCategorySheetState extends State<AddCategorySheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _addCategory() {
    if (_formKey.currentState!.validate()) {
      final request = AddCategoryRequestModel(
        name: _nameController.text.trim(),
      );

      context.read<CategoryBloc>().add(AddCategoryEvent(request));
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
              'Tambah Kategori',
              style: primaryTextStyle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Expanded(
            child: BlocListener<CategoryBloc, CategoryState>(
              listener: (context, state) {
                if (state is CategoryAdded) {
                  Navigator.pop(
                      context, true); // Return true untuk indicate success
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Kategori berhasil ditambahkan'),
                      backgroundColor: primaryColor,
                    ),
                  );
                } else if (state is CategoryError) {
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
                      // Icon Section
                      Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(60),
                          ),
                          child: Icon(
                            Icons.category_outlined,
                            size: 60,
                            color: primaryColor,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Category Name Field
                      Text(
                        'Nama Kategori',
                        style: primaryTextStyle.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'Masukkan nama kategori',
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
                            return 'Nama kategori tidak boleh kosong';
                          }
                          if (value.trim().length < 3) {
                            return 'Nama kategori minimal 3 karakter';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      // Status feedback
                      BlocBuilder<CategoryBloc, CategoryState>(
                        builder: (context, state) {
                          if (state is CategoryLoading) {
                            return Row(
                              children: [
                                const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Menambahkan kategori...',
                                  style: primaryTextStyle.copyWith(
                                    fontSize: 14,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            );
                          } else if (state is CategoryAdded) {
                            return Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Kategori berhasil ditambahkan',
                                  style: primaryTextStyle.copyWith(
                                    color: Colors.green,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            );
                          } else if (state is CategoryError) {
                            return Row(
                              children: [
                                Icon(
                                  Icons.error,
                                  color: Colors.red,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Gagal menambahkan kategori: ${state.message}',
                                    style: primaryTextStyle.copyWith(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                          return Container();
                        },
                      ),

                      const SizedBox(height: 24),
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
            child: BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                final isLoading = state is CategoryLoading;

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
                        onPressed: isLoading ? null : _addCategory,
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
