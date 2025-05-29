import 'package:flutter/material.dart';
import 'package:mas_pos_app/commons/theme.dart';
import 'package:mas_pos_app/feature/category/presentation/widgets/add_category_helper.dart';
import 'add_product_sheet.dart';

/// Helper function untuk menampilkan modal bottom sheet add product
Future<bool?> showAddProductSheet(BuildContext context) async {
  return await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      final height = MediaQuery.of(context).size.height * 0.25;
      return Container(
        height: height,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  Navigator.of(context).pop();
                  await showAddCategorySheet(context);
                },
                child: Container(
                  height: 125,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: primaryColor.withValues(alpha: 0.2),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.add_box, color: primaryColor, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            'Kategori',
                            style: primaryTextStyle.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Buat menu produk lebih rapi',
                        style: secondaryTextStyle.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 16), // Spacing between buttons
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  Navigator.of(context).pop();
                  await showModalBottomSheet<bool>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => Container(
                      height: MediaQuery.of(context).size.height * 0.9,
                      child: const AddProductSheet(),
                    ),
                  );
                },
                child: Container(
                  height: 125,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: primaryColor.withValues(alpha: 0.2),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.add_box, color: primaryColor, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            'Produk',
                            style: primaryTextStyle.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tambahin makanan atau minuman ',
                        style: secondaryTextStyle.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
