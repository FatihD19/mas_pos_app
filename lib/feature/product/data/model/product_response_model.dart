class ProductResponseModel {
  int? status;
  String? message;
  List<Product>? data;

  ProductResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) =>
      ProductResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Product>.from(json["data"]!.map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class AddProductResponseModel {
  String? message;
  Product? data;

  AddProductResponseModel({
    this.message,
    this.data,
  });

  factory AddProductResponseModel.fromJson(Map<String, dynamic> json) =>
      AddProductResponseModel(
        message: json["message"],
        data: json["data"] == null ? null : Product.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data?.toJson(),
      };
}

class Product {
  String? id;
  String? categoryId;
  String? name;
  int? price;
  String? pictureUrl;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  Product({
    this.id,
    this.categoryId,
    this.name,
    this.price,
    this.pictureUrl,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        categoryId: json["category_id"],
        name: json["name"],
        price: json["price"] is int
            ? json["price"]
            : int.tryParse(json["price"]?.toString() ?? ''),
        pictureUrl: json["picture_url"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "name": name,
        "price": price,
        "picture_url": pictureUrl,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
      };
}
