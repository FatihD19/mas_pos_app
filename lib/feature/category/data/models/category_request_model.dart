class AddCategoryRequestModel {
  String? name;

  AddCategoryRequestModel({
    this.name,
  });

  factory AddCategoryRequestModel.fromJson(Map<String, dynamic> json) =>
      AddCategoryRequestModel(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
