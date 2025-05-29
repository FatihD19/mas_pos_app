class CategoryResponseModel {
  int? status;
  String? message;
  List<CategoryModel>? data;

  CategoryResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory CategoryResponseModel.fromJson(Map<String, dynamic> json) =>
      CategoryResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<CategoryModel>.from(
                json["data"]!.map((x) => CategoryModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class CategoryModel {
  String? id;
  String? name;
  DateTime? createdAt;

  CategoryModel({
    this.id,
    this.name,
    this.createdAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"],
        name: json["name"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt?.toIso8601String(),
      };
}

class AddCategoryResponseModel {
  String? message;
  Data? data;

  AddCategoryResponseModel({
    this.message,
    this.data,
  });

  factory AddCategoryResponseModel.fromJson(Map<String, dynamic> json) =>
      AddCategoryResponseModel(
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  String? name;
  String? id;

  Data({
    this.name,
    this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        name: json["name"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
}
