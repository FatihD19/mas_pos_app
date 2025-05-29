class CartItem {
  final String productId;
  final String name;
  final int price;
  final String pictureUrl;
  int quantity;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.pictureUrl,
    this.quantity = 1,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        productId: json["product_id"],
        name: json["name"],
        price: json["price"],
        pictureUrl: json["picture_url"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "name": name,
        "price": price,
        "picture_url": pictureUrl,
        "quantity": quantity,
      };

  // Method untuk menghitung total harga item
  int get totalPrice => price * quantity;

  // Copy dengan method untuk update quantity
  CartItem copyWith({
    String? productId,
    String? name,
    int? price,
    String? pictureUrl,
    int? quantity,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      pictureUrl: pictureUrl ?? this.pictureUrl,
      quantity: quantity ?? this.quantity,
    );
  }
}
