import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mas_pos_app/commons/theme.dart';
import 'package:mas_pos_app/feature/category/presentation/bloc/category_bloc.dart';
import 'package:mas_pos_app/feature/category/data/models/category_response_model.dart';
import 'package:mas_pos_app/feature/product/presentation/bloc/product_bloc.dart';

class CategoryFilterChips extends StatefulWidget {
  const CategoryFilterChips({super.key});

  @override
  State<CategoryFilterChips> createState() => _CategoryFilterChipsState();
}

class _CategoryFilterChipsState extends State<CategoryFilterChips> {
  String? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    // Load categories when widget initializes
    context.read<CategoryBloc>().add(GetCategoriesEvent());
  }

  void _onCategorySelected(String? categoryId) {
    setState(() {
      selectedCategoryId = categoryId;
    });

    // Trigger filter event
    context.read<ProductBloc>().add(FilterProductEvent(categoryId));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 16),
      child: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          }

          if (state is CategoryLoaded && state.category.data != null) {
            final categories = state.category.data!;

            return ListView(
              scrollDirection: Axis.horizontal,
              children: [
                // Chip "Semua Menu" (default)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(
                      'Semua Menu',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: selectedCategoryId == null
                            ? Colors.white
                            : primaryColor,
                      ),
                    ),
                    selected: selectedCategoryId == null,
                    onSelected: (selected) {
                      if (selected) {
                        _onCategorySelected(null);
                      }
                    },
                    backgroundColor: Colors.grey[100],
                    selectedColor: primaryColor,
                    checkmarkColor: Colors.white,
                    side: BorderSide(
                      color: selectedCategoryId == null
                          ? primaryColor
                          : Colors.grey[300]!,
                      width: 1,
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),

                // Category chips
                ...categories
                    .map((category) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(
                              category.name ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: selectedCategoryId == category.id
                                    ? Colors.white
                                    : primaryColor,
                              ),
                            ),
                            selected: selectedCategoryId == category.id,
                            onSelected: (selected) {
                              if (selected) {
                                _onCategorySelected(category.id);
                              } else {
                                _onCategorySelected(null);
                              }
                            },
                            backgroundColor: Colors.grey[100],
                            selectedColor: primaryColor,
                            checkmarkColor: Colors.white,
                            side: BorderSide(
                              color: selectedCategoryId == category.id
                                  ? primaryColor
                                  : Colors.grey[300]!,
                              width: 1,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                        ))
                    .toList(),
              ],
            );
          }

          if (state is CategoryError) {
            return Center(
              child: Text(
                'Error loading categories',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                ),
              ),
            );
          }

          return Center(
            child: Text(
              'No categories available',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          );
        },
      ),
    );
  }
}
