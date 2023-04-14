import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:scanner_cooker/database/database.dart';
import 'package:scanner_cooker/spoonacular/models/recipe_details.dart';


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
    var count = Database.getRecords().toString();
    return Item(id: count, products: "", title: "", recipe: "");
  }

  factory Item.fromJson(Map<String, dynamic> json) =>
      Item(
        id: json["id"],
        title: json["title"],
        products: json["name"],
        recipe: json["recipe"],
      );

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "title": title,
        "products": products,
        "recipe": recipe,
      };

  static Item createItemFromModel(RecipeDetails recipe, String products) {
    if (kDebugMode) {
      print("products createItemFromModel: $products");
    }

    String count = "";

    if (recipe.id == null) {
      count = Database.getRecords().toString();
    }
    else {
      count = recipe.id.toString();
    }

    Item item = Item(id: count,
        products: products,
        title: recipe.title,
        recipe: recipe.instructions);

    if (kDebugMode) {
      print(item.products);
    }
    return item;
  }

}