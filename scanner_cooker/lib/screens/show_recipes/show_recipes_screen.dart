import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scanner_cooker/database/recipeItem.dart';
import 'package:scanner_cooker/screens/show_recipes/dialogs/custom_edit_dialog.dart';
import 'package:scanner_cooker/screens/show_recipes/dialogs/custom_show_recipes.dart';
import 'package:scanner_cooker/utils/color_utils.dart';
import 'package:scanner_cooker/utils/constants.dart';

import '../../database/database.dart';
import 'toast_Information.dart';
import 'dialogs/custom_find_dialog.dart';

const String collectionUsers = "users";
const String recipies = "recipes";

class ShowRecipesScreen extends StatefulWidget {
  const ShowRecipesScreen({Key? key}) : super(key: key);

  @override
  State<ShowRecipesScreen> createState() => _ShowRecipesScreenState();
}

class _ShowRecipesScreenState extends State<ShowRecipesScreen> {
  List<Item> recipeItems = [];
  List<Item> tmpRecipeItems = [];
  String user = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    Database.fetchRecords();
    super.initState();
    FirebaseFirestore.instance
        .collection(collectionUsers)
        .doc(user)
        .collection(recipies)
        .snapshots(includeMetadataChanges: true)
        .listen((records) {
      var list = Database.mapRecords(records);

      if (mounted) {
        // check whether the state object is in tree
        setState(() {
          recipeItems = list;
        });
      }
      //recipeItems = [];
    }).onError((e) => showMessage(e.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: stringToColorInHex(Constants.backgroundColorHex),
        appBar: AppBar(
          title: const Text("Favorite recipies"),
          backgroundColor:
              stringToColorInHex(Constants.backgroundColorHex).withOpacity(.25),
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 20),
                child: IconButton(
                    onPressed: () {
                      searchDialog(context, recipeItems);
                    },
                    icon: const Icon(Icons.search)))
          ],
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.white,
            child: const Icon(Icons.add, color: Colors.black),
            onPressed: () {
              customDialog(null, "ADD", context, Database.editItem);
            }),
        body: Container(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: recipeItems.isNotEmpty
                ? ListView.builder(
                    itemCount: recipeItems.length,
                    itemBuilder: (context, index) {
                      return Card(
                          color:
                              stringToColorInHex(Constants.backgroundColorHex),
                          child: ListTile(
                            leading: IconButton(
                                onPressed: () {
                                  customDialog(recipeItems[index], "EDIT",
                                      context, Database.editItem);
                                },
                                icon: const Icon(Icons.edit)),
                            trailing: IconButton(
                              onPressed: () {
                                Database.deleteItem(recipeItems[index].id);
                              },
                              icon: const Icon(Icons.delete),
                            ),
                            title: Text(recipeItems[index].products),
                            subtitle: Text(recipeItems[index].title ?? ''),
                            onTap: () {
                              customShowDialog(recipeItems[index], context);
                            },
                            tileColor: Colors.white.withOpacity(0.4),
                          ));
                    })
                : Container(
                    alignment: Alignment.center,
                    child: const Text(
                      "List is empty",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ))));
  }
}
