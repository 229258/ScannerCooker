import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scanner_cooker/database/recipe.dart';

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
    }).catchError((e)=>debugPrint(e.toString()));

  }

  static mapRecords(QuerySnapshot<Map<String, dynamic>> records)
  {
    var _list = records.docs.map((item) => Item(
        id: item.id,
        products: item['products'],
        recipe: item['recipe']),
    ).toList();
    print(_list);

    return _list;
  }

  static bool addItem(String products, String recipe)
  {
    String user = getUser();
    bool res = false;

    if ((products != null) && (recipe != null))
    {
      var item = Item(id: 'id', products: products, recipe: recipe);

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

  static void _showMessage(String text)
  {
    Fluttertoast.showToast(msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
  }


  static deleteItem(String id) {
      String user = getUser();
      FirebaseFirestore.instance.collection(COLLECTION_USERS).doc(user)
          .collection(RECIPES).doc(id).delete()
          .catchError((e) => _showMessage("error: ${e.toString()}"));
  }

  static bool editItem(String id, String recipe)
  {
    var res = false;
    try {
      String user = getUser();
      FirebaseFirestore.instance.collection(COLLECTION_USERS).doc(user).collection(RECIPES).doc(id).update(
        {
          "recipe": recipe
        }
      );
      res = true;
    } on IOException catch (e) {
        rethrow;
    }
    return res;
  }

  static void searchItem(String products)
  {
    print(products);
  }

}




