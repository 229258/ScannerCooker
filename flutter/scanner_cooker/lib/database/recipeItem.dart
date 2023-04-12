import 'dart:convert';

import 'package:scanner_cooker/database/database.dart';
import 'package:scanner_cooker/spoonacular/models/recipe_details.dart';

import '../spoonacular/models/recipe.dart';

Item itemFromJson(String str) => Item.fromJson(json.decode(str));

String itemToJson(Item data) => json.encode(data.toJson());

class Item {

  Item({
    required this.id,
    required this.products,
    this.title,
    this.recipe,
  });

  String id;
  String products;
  String? title;
  String? recipe;


  factory Item.empty()
  {
    return Item(id: "-1", products: "", title: "", recipe: "");
  }

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    title: json["title"],
    products: json["name"],
    recipe: json["recipe"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "products": products,
    "recipe": recipe,
  };

  static Item createItemFromModel(RecipeDetails recipe, String products)
  {
    print("products createItemFromModel: ${products}");

    String tmp = recipe.id.toString();

    if (recipe.id == null)
    {
      var count = -1;
      tmp = count.toString();
    }

    Item item = new Item(id: tmp, products: products, title: recipe.title, recipe: recipe.instructions);

    print(item.products);
    return item;
  }

}