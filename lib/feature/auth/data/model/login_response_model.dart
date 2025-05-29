class LoginResponseModel {
  Data? data;
  String? message;

  LoginResponseModel({
    this.data,
    this.message,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "message": message,
      };
}

class Data {
  String? id;
  String? name;
  String? email;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? token;

  Data({
    this.id,
    this.name,
    this.email,
    this.createdAt,
    this.updatedAt,
    this.token,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "token": token,
      };
}
