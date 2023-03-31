import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scanner_cooker/database/recipe.dart';


String COLLECTION_USERS = "users";
String RECIPES = "recipes";

class Database
{
  String user = "";
  Database(this.user);

  bool addItem(String products, String recipe)
  {
    if ((products != null) && (recipe != null))
    {
      var item = Item(id: 'id', products: products, recipe: recipe);
      FirebaseFirestore.instance.collection(COLLECTION_USERS).doc(user).collection(RECIPES).add(item.toJson());
      return true;
    }
    else
    {
      return false;
    }

  }

  deleteItem(String id)
  {
    FirebaseFirestore.instance.collection(COLLECTION_USERS).doc(user).collection(RECIPES).doc(id).delete();
  }
}


