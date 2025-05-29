import 'package:equatable/equatable.dart';
import '../../../data/model/cart_item_model.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> cartItems;
  final int totalItems;
  final int totalPrice;

  const CartLoaded({
    required this.cartItems,
    required this.totalItems,
    required this.totalPrice,
  });

  @override
  List<Object> get props => [cartItems, totalItems, totalPrice];

  CartLoaded copyWith({
    List<CartItem>? cartItems,
    int? totalItems,
    int? totalPrice,
  }) {
    return CartLoaded(
      cartItems: cartItems ?? this.cartItems,
      totalItems: totalItems ?? this.totalItems,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object> get props => [message];
}
