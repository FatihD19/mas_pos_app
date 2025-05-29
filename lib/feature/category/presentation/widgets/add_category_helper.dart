import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mas_pos_app/feature/category/presentation/bloc/category_bloc.dart';
import 'package:mas_pos_app/core/di/service_locator.dart';
import 'add_category_sheet.dart';

/// Helper function untuk menampilkan modal bottom sheet add category
Future<bool?> showAddCategorySheet(BuildContext context) async {
  return await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: const AddCategorySheet(),
    ),
  );
}
