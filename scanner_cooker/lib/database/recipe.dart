import 'dart:convert';

Item itemFromJson(String str) => Item.fromJson(json.decode(str));

String itemToJson(Item data) => json.encode(data.toJson());

class Item {
  Item({
    required this.id,
    required this.products,
    this.recipe,
  });

  String id;
  String products;
  String? recipe;


  factory Item.empty()
  {
    return Item(id: "id", products: "", recipe: "");
  }

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    products: json["name"],
    recipe: json["recipe"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "products": products,
    "recipe": recipe,
  };
}