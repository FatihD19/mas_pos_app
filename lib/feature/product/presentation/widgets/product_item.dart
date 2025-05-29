import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mas_pos_app/commons/theme.dart';
import 'package:mas_pos_app/feature/product/data/model/product_response_model.dart';
import 'package:mas_pos_app/feature/product/presentation/bloc/product/product_bloc.dart';
import 'package:mas_pos_app/utils/utils.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';

class ProductItem extends StatelessWidget {
  final Product data;
  const ProductItem({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 175,
      height: 250,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).toInt()),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  image: DecorationImage(
                    image: NetworkImage(data.pictureUrl ?? ''),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    context
                        .read<ProductBloc>()
                        .add(DeleteProductEvent("${data.id}"));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.2),
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(Icons.delete_outline_outlined,
                        color: Colors.white, size: 20),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${data.name}",
                    style: primaryTextStyle.copyWith(fontSize: 15)),
                const SizedBox(height: 4),
                Text(
                  "${RupiahFormatter.format(data.price ?? 0)}",
                  style: secondaryTextStyle.copyWith(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      onPressed: () {
                        // Add product to cart
                        context.read<CartBloc>().add(AddToCart(data));

                        // Show snackbar confirmation
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('${data.name} ditambahkan ke keranjang'),
                            duration: const Duration(seconds: 2),
                            backgroundColor: primaryColor,
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text("Tambah", style: buttonTextStyle),
                        ],
                      )),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
