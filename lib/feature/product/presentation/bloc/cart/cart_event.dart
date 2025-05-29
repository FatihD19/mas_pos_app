import 'package:equatable/equatable.dart';
import '../../../data/model/cart_item_model.dart';
import '../../../data/model/product_response_model.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class LoadCart extends CartEvent {}

class AddToCart extends CartEvent {
  final Product product;

  const AddToCart(this.product);

  @override
  List<Object> get props => [product];
}

class UpdateCartItemQuantity extends CartEvent {
  final String productId;
  final int quantity;

  const UpdateCartItemQuantity(this.productId, this.quantity);

  @override
  List<Object> get props => [productId, quantity];
}

class RemoveFromCart extends CartEvent {
  final String productId;

  const RemoveFromCart(this.productId);

  @override
  List<Object> get props => [productId];
}

class ClearCart extends CartEvent {}
