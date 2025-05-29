class AddProductRequestModel {
  final String categoryId;
  final String name;
  final int price;
  final String? picturePath; // Path file gambar (opsional)

  AddProductRequestModel({
    required this.categoryId,
    required this.name,
    required this.price,
    this.picturePath,
  });
}
