import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mas_pos_app/commons/app_assets.dart';
import 'package:mas_pos_app/commons/theme.dart';
import 'package:mas_pos_app/feature/product/presentation/pages/transaction_page.dart';
import 'package:mas_pos_app/utils/utils.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';
import '../bloc/cart/cart_state.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    // Load cart when page is opened
    context.read<CartBloc>().add(LoadCart());
  }

  String? _selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    Widget paymentType() {
      String paymentMethod = _selectedPaymentMethod ?? 'Pilih Metode';
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Bayar Menggunakan: ",
              style: secondaryTextStyle.copyWith(fontSize: 14)),
          Row(
            children: [
              Row(
                children: [
                  _selectedPaymentMethod == null
                      ? SizedBox()
                      : Image.asset(
                          _selectedPaymentMethod == 'cash'
                              ? appAsset["ic_cash"]!
                              : appAsset["ic_qris"]!,
                          width: 24,
                          height: 24,
                        ),
                  Text(
                    paymentMethod == 'cash'
                        ? ' Cash'
                        : paymentMethod == 'qris'
                            ? ' QRIS'
                            : '',
                    style: primaryTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward_ios_outlined),
                onPressed: () async {
                  final selected = await showModalBottomSheet<String>(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    builder: (context) {
                      String? tempSelected = _selectedPaymentMethod;
                      return StatefulBuilder(
                        builder: (context, setModalState) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Pilih Metode Pembayaran',
                                    style: primaryTextStyle.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            appAsset["ic_cash"]!,
                                            width: 32,
                                            height: 32,
                                          ),
                                          const SizedBox(width: 8),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Tunai",
                                                  style:
                                                      primaryTextStyle.copyWith(
                                                          fontWeight: bold)),
                                              Text("Support text",
                                                  style: secondaryTextStyle
                                                      .copyWith(
                                                          fontSize: 14,
                                                          fontWeight: bold)),
                                            ],
                                          )
                                        ],
                                      ),
                                      Radio<String>(
                                        value: 'cash',
                                        groupValue: tempSelected,
                                        onChanged: (value) {
                                          setModalState(
                                              () => tempSelected = value);
                                          Navigator.pop(context, value);
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 30),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            appAsset["ic_qris"]!,
                                            width: 32,
                                            height: 32,
                                          ),
                                          const SizedBox(width: 8),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Qris",
                                                  style:
                                                      primaryTextStyle.copyWith(
                                                          fontWeight: bold)),
                                              Text("Support text",
                                                  style: secondaryTextStyle
                                                      .copyWith(
                                                          fontSize: 14,
                                                          fontWeight: bold)),
                                            ],
                                          )
                                        ],
                                      ),
                                      Radio<String>(
                                        value: 'qris',
                                        groupValue: tempSelected,
                                        onChanged: (value) {
                                          setModalState(
                                              () => tempSelected = value);
                                          Navigator.pop(context, value);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                  if (selected != null) {
                    setState(() {
                      _selectedPaymentMethod = selected;
                    });
                  }
                },
              ),
            ],
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Keranjang',
            style: primaryTextStyle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            )),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoaded && state.cartItems.isNotEmpty) {
                return TextButton(
                  onPressed: () {
                    _showClearCartDialog(context);
                  },
                  child: Text(
                    'Hapus Semua',
                    style: primaryTextStyle.copyWith(
                      fontSize: 14,
                      color: Colors.red,
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CartError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: secondaryTextStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CartBloc>().add(LoadCart());
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          if (state is CartLoaded) {
            if (state.cartItems.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 100,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Keranjang Kosong',
                      style: primaryTextStyle.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tambahkan produk untuk melanjutkan',
                      style: secondaryTextStyle,
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = state.cartItems[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withAlpha((0.05 * 255).toInt()),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Product Image
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(item.pictureUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Product Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: primaryTextStyle.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${RupiahFormatter.format(item.price)} ',
                                    style: secondaryTextStyle.copyWith(
                                        fontSize: 12),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    'Total: ${RupiahFormatter.format(item.price)}',
                                    style: primaryTextStyle.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Quantity Controls
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    context.read<CartBloc>().add(
                                          RemoveFromCart(item.productId),
                                        );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.red[400]!,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Icon(
                                      Icons.delete_outline_outlined,
                                      size: 18,
                                      color: Colors.red[400],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (item.quantity > 1) {
                                            context.read<CartBloc>().add(
                                                  UpdateCartItemQuantity(
                                                    item.productId,
                                                    item.quantity - 1,
                                                  ),
                                                );
                                          }
                                        },
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: item.quantity > 1
                                                ? primaryColor
                                                : Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Icon(
                                            Icons.remove,
                                            size: 16,
                                            color: item.quantity > 1
                                                ? Colors.white
                                                : Colors.grey[600],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 40,
                                        alignment: Alignment.center,
                                        child: Text(
                                          item.quantity.toString(),
                                          style: primaryTextStyle.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          context.read<CartBloc>().add(
                                                UpdateCartItemQuantity(
                                                  item.productId,
                                                  item.quantity + 1,
                                                ),
                                              );
                                        },
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: const Icon(
                                            Icons.add,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Bottom Summary
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((0.1 * 255).toInt()),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      paymentType(),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Items:',
                            style: secondaryTextStyle.copyWith(fontSize: 14),
                          ),
                          Text(
                            '${state.totalItems} item',
                            style: primaryTextStyle.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Harga:',
                            style: primaryTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${RupiahFormatter.format(state.totalPrice)}',
                            style: primaryTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: _selectedPaymentMethod == null
                              ? null
                              : () {
                                  // TODO: Implement checkout functionality
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PaymentSuccessScreen(
                                                  total: state.totalPrice,
                                                  paymentMethod:
                                                      _selectedPaymentMethod!)));
                                },
                          child: Text(
                            'Checkout',
                            style: buttonTextStyle.copyWith(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void _showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Hapus Keranjang',
            style: primaryTextStyle.copyWith(fontWeight: FontWeight.w600),
          ),
          content: Text(
            'Apakah Anda yakin ingin menghapus semua item dari keranjang?',
            style: secondaryTextStyle,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal', style: secondaryTextStyle),
            ),
            TextButton(
              onPressed: () {
                context.read<CartBloc>().add(ClearCart());
                Navigator.pop(context);
              },
              child: Text(
                'Hapus',
                style: primaryTextStyle.copyWith(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
