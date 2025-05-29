import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/datasource/product_local_datasource.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final ProductLocalDatasource _localDatasource;

  CartBloc(this._localDatasource) : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<UpdateCartItemQuantity>(_onUpdateCartItemQuantity);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<ClearCart>(_onClearCart);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    try {
      emit(CartLoading());

      final cartItems = await _localDatasource.getCartItems();
      final totalItems = await _localDatasource.getCartItemsCount();
      final totalPrice = await _localDatasource.getCartTotalPrice();

      emit(CartLoaded(
        cartItems: cartItems,
        totalItems: totalItems,
        totalPrice: totalPrice,
      ));
    } catch (e) {
      emit(CartError('Failed to load cart: ${e.toString()}'));
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    try {
      final success = await _localDatasource.addToCart(event.product);

      if (success) {
        // Reload cart after successful addition
        add(LoadCart());
      } else {
        emit(const CartError('Failed to add product to cart'));
      }
    } catch (e) {
      emit(CartError('Failed to add product to cart: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateCartItemQuantity(
    UpdateCartItemQuantity event,
    Emitter<CartState> emit,
  ) async {
    try {
      final success = await _localDatasource.updateCartItemQuantity(
        event.productId,
        event.quantity,
      );

      if (success) {
        // Reload cart after successful update
        add(LoadCart());
      } else {
        emit(const CartError('Failed to update cart item quantity'));
      }
    } catch (e) {
      emit(CartError('Failed to update cart item quantity: ${e.toString()}'));
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      final success = await _localDatasource.removeFromCart(event.productId);

      if (success) {
        // Reload cart after successful removal
        add(LoadCart());
      } else {
        emit(const CartError('Failed to remove item from cart'));
      }
    } catch (e) {
      emit(CartError('Failed to remove item from cart: ${e.toString()}'));
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    try {
      final success = await _localDatasource.clearCart();

      if (success) {
        // Reload cart after successful clear
        add(LoadCart());
      } else {
        emit(const CartError('Failed to clear cart'));
      }
    } catch (e) {
      emit(CartError('Failed to clear cart: ${e.toString()}'));
    }
  }
}
