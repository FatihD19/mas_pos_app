import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/cart_item_model.dart';
import '../model/product_response_model.dart';

class ProductLocalDatasource {
  static const String _cartKey = 'cart_items';

  // Singleton pattern
  static ProductLocalDatasource? _instance;
  static ProductLocalDatasource get instance {
    _instance ??= ProductLocalDatasource._internal();
    return _instance!;
  }

  ProductLocalDatasource._internal();

  // Get semua cart items
  Future<List<CartItem>> getCartItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartString = prefs.getString(_cartKey);

      if (cartString == null) return [];

      final List<dynamic> cartJson = json.decode(cartString);
      return cartJson.map((item) => CartItem.fromJson(item)).toList();
    } catch (e) {
      return [];
    }
  }

  // Add product to cart
  Future<bool> addToCart(Product product) async {
    try {
      final cartItems = await getCartItems();

      // Cek apakah product sudah ada di cart
      final existingIndex = cartItems.indexWhere(
        (item) => item.productId == product.id,
      );

      if (existingIndex != -1) {
        // Jika sudah ada, tambah quantity
        cartItems[existingIndex].quantity += 1;
      } else {
        // Jika belum ada, tambah item baru
        final newCartItem = CartItem(
          productId: product.id ?? '',
          name: product.name ?? '',
          price: product.price ?? 0,
          pictureUrl: product.pictureUrl ?? '',
          quantity: 1,
        );
        cartItems.add(newCartItem);
      }

      return await _saveCartItems(cartItems);
    } catch (e) {
      return false;
    }
  }

  // Update quantity item di cart
  Future<bool> updateCartItemQuantity(String productId, int quantity) async {
    try {
      final cartItems = await getCartItems();
      final index = cartItems.indexWhere(
        (item) => item.productId == productId,
      );

      if (index != -1) {
        if (quantity <= 0) {
          // Jika quantity 0 atau kurang, hapus item
          cartItems.removeAt(index);
        } else {
          cartItems[index].quantity = quantity;
        }
        return await _saveCartItems(cartItems);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Remove item dari cart
  Future<bool> removeFromCart(String productId) async {
    try {
      final cartItems = await getCartItems();
      cartItems.removeWhere((item) => item.productId == productId);
      return await _saveCartItems(cartItems);
    } catch (e) {
      return false;
    }
  }

  // Clear semua cart
  Future<bool> clearCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_cartKey);
    } catch (e) {
      return false;
    }
  }

  // Get total items count di cart
  Future<int> getCartItemsCount() async {
    try {
      final cartItems = await getCartItems();
      int total = 0;
      for (var item in cartItems) {
        total += item.quantity;
      }
      return total;
    } catch (e) {
      return 0;
    }
  }

  // Get total price dari semua items di cart
  Future<int> getCartTotalPrice() async {
    try {
      final cartItems = await getCartItems();
      int total = 0;
      for (var item in cartItems) {
        total += item.totalPrice;
      }
      return total;
    } catch (e) {
      return 0;
    }
  }

  // Private method untuk save cart items ke SharedPreferences
  Future<bool> _saveCartItems(List<CartItem> cartItems) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = cartItems.map((item) => item.toJson()).toList();
      final cartString = json.encode(cartJson);
      return await prefs.setString(_cartKey, cartString);
    } catch (e) {
      return false;
    }
  }
}
