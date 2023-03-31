import 'dart:convert';
import 'package:scanner_cooker/database/recipe.dart';

UserData userFromJson(String str) => UserData.fromJson(json.decode(str));

String userToJson(UserData data) => json.encode(data.toJson());

class UserData {
  UserData({
    required this.id,
    this.recipes,
  });

  String id;
  List<Item>? recipes;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    id: json["id"],
    recipes: json["recipes"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "recipes": recipes,
  };
}