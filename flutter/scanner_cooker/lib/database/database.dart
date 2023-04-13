import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scanner_cooker/database/recipeItem.dart';
import 'package:scanner_cooker/spoonacular/models/recipe.dart';

import '../screens/show_recipes/toast_Information.dart';
import '../spoonacular/models/recipe_details.dart';

String COLLECTION_USERS = "users";
String RECIPES = "recipes";


class Database
{
  static String getUser()
  {
    String user = "";

    try
    {
      user = FirebaseAuth.instance.currentUser!.uid;
    }catch(e)
    {
      Fluttertoast.showToast(msg: "Error: ${e.toString()}", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, textColor: Colors.white, fontSize: 16.0);
    }

    return user;
  }

  static void fetchRecords() async
  {
    String user = getUser();

      await FirebaseFirestore.instance
          .collection(COLLECTION_USERS)
          .doc(user)
          .collection(RECIPES)
          .get()
      .then((records)
      {
        records.docs.isNotEmpty ? mapRecords(records) : null;
    }).catchError((e)=>showMessage("Problem with load actual data ${e.toString()}"));

  }

  static mapRecords(QuerySnapshot<Map<String, dynamic>> records)
  {
    var _list = records.docs.map((item) => Item(
        id: item.id,
        title: item['title'],
        products: item['products'],
        recipe: item['recipe']),
    ).toList();
    print(_list);

    return _list;
  }


  static bool addItemFromModel(RecipeDetails recipe, String products)
  {
    String user = getUser();
    bool res = false;

    print(products);

    Item item = Item.createItemFromModel(recipe, products);

    try {
        FirebaseFirestore.instance.collection(COLLECTION_USERS).doc(user)
            .collection(RECIPES)
            .add(item.toJson());
      } catch (e) {
        res = false;
      }

      res =  true;

    print(res.toString());
    return res;
  }


  static bool addItem(String products, String title, String recipe)
  {
    String user = getUser();
    bool res = false;
    int count = -1;

    getRecords()
    .then((value) {
      if (kDebugMode) {
        print(value);
      }
      count = value;
    }).
    catchError((e)=>showMessage(e));

    if ((products != null) && (recipe != null))
    {
      var item = Item(id: count.toString(), title: title, products: products, recipe: recipe);

      try {
        FirebaseFirestore.instance.collection(COLLECTION_USERS).doc(user)
            .collection(RECIPES)
            .add(item.toJson());
      } catch (e) {
        res = false;
      }

      res =  true;
    }

    print(res.toString());
    return res;
  }

  /*static void showMessage(String text)
  {
    Fluttertoast.showToast(msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
  }*/


  static deleteItem(String id) {
    String user = getUser();
    print(id);
    FirebaseFirestore.instance.collection(COLLECTION_USERS).doc(user)
        .collection(RECIPES).doc(id).delete()
        .catchError((e) => showMessage("Can't delete item: ${e.toString()}"));
  }

  static bool editItem(String? id, String title, String products, String recipe)
  {
    var res = false;

    if (id == null)
    {
        return addItem(products, title, recipe);
    }
    else
      {
        String user = getUser();
        FirebaseFirestore.instance.collection(COLLECTION_USERS).doc(user).collection(RECIPES).doc(id).update(
            {
              "products": products,
              "title": title,
              "recipe": recipe
            }
        ).catchError((e)=>showMessage("Can't edit item ${e.toString()}"));
        res = true;
      }

    return res;
  }


  static List<Item> searchItem(String search, List<Item> prod)
  {
    Map<Item, int> map = {};

    String result1 = search.replaceAll(RegExp('[^A-Za-z]'), " ");

    List<String> search_products = result1.split(" ").toList();

    search_products.removeWhere((element) => (element.compareTo('') == 0));

    var counter = 0;

    print(search_products);
    List<Item> list = [];

    if (prod.isEmpty)
    {
        return list;
    }

    for (var p in prod)
    {
      for (var s in search_products)
      {
        if (p.products.toLowerCase().contains(s.trim().toLowerCase()))
        {
          counter++;
        }
      }

      if (counter != 0)
      {
        map.putIfAbsent(p, () => counter);
      }
      counter = 0;
    }

    list = (Map.fromEntries(map.entries.toList()..sort((e1, e2) => e1.value.compareTo(e2.value)))).keys.toList();

    return list;
  }

  static Future<int> getRecords() async
  {
    var user = getUser();

    int count = -1;

    var list = await FirebaseFirestore.instance.collection(COLLECTION_USERS).doc(user)
        .collection(RECIPES).snapshots().toList().catchError((e)=>showMessage("We can't load number of items"));

    count = list.length;

    print("getRecords ${list.length}");

    return count;
  }


}




