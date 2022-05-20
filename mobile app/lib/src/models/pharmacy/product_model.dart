class ProductModel {
  ProductModel({
    this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.description,
  });
  final id;
  final String name;
  final String image;
  final String price;
  final String description;

  static List<String> pharmacyProducts = [
    "Antibiotics",
    "Antimalarial drugs",
    "Antidiabetic drugs",
  ];
  ProductModel.fromJson(json)
      : id = json["id"],
        name = json["name"],
        image = json["image"],
        price = json["price"],
        description = json["description"];
}
