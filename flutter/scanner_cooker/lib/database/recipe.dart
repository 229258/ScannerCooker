import 'dart:convert';

Recipe itemFromJson(String str) => Recipe.fromJson(json.decode(str));

String itemToJson(Recipe data) => json.encode(data.toJson());

class Recipe {
  Recipe({
    required this.id,
    required this.products,
    required this.recipe,
  });

  String id;
  String name;
  String? quantity;

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
    id: json["id"],
    products: json["products"],
    recipe: json["recipe"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "products": products,
    "recipe": recipe,
  };
}