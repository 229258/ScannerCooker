import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scanner_cooker/database/recipeItem.dart';
import 'package:scanner_cooker/screens/show_recipes/dialogs/custom_edit_dialog.dart';
import 'package:scanner_cooker/screens/show_recipes/dialogs/custom_show_recipes.dart';

import '../../database/database.dart';
import 'toast_Information.dart';
import 'dialogs/custom_find_dialog.dart';

String COLLECTION_USERS = "users";
String RECIPES = "recipes";

class ShowRecipesScreen extends StatefulWidget {
  const ShowRecipesScreen({Key? key}) : super(key: key);

  @override
  State<ShowRecipesScreen> createState() => _ShowRecipesScreenState();
}

class _ShowRecipesScreenState extends State<ShowRecipesScreen>
{
  List<Item> recipeItems = [];
  List<Item> tmpRecipeItems = [];
  String user = FirebaseAuth.instance.currentUser!.uid;


  @override
  void initState()
  {
    Database.fetchRecords();
    super.initState();
        FirebaseFirestore.instance.collection(COLLECTION_USERS).doc(user).collection(RECIPES).snapshots(includeMetadataChanges: true).listen((records)
        {
          var list = Database.mapRecords(records);

          if (mounted) { // check whether the state object is in tree
            setState(() {
              recipeItems = list;
            });
          }
          //recipeItems = [];
        }).onError((e)=>showMessage(e.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("FAVORITE RECIPIES"),
          actions: [
            IconButton(
                onPressed: (){searchDialog(context, recipeItems);},
                icon: const Icon(Icons.search)
            )
          ],
      ),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add), onPressed: () {customDialog(null, "ADD", context, Database.editItem);}),
      body:
        ListView.builder(
          itemCount: recipeItems.length,
          itemBuilder: (context, index){
            return Card(
                  color: Colors.blue,
                    child: ListTile(
                  leading: IconButton(onPressed: () { customDialog(recipeItems[index], "EDIT", context, Database.editItem);}, icon: Icon(Icons.edit)),
                  trailing: IconButton(onPressed: () { Database.deleteItem(recipeItems[index].id); }, icon: Icon(Icons.delete),),
                  title: Text(recipeItems[index].products),
                  subtitle: Text(recipeItems[index].title ?? ''),
                      onTap: () {
                        customShowDialog(recipeItems[index], context);
                      }
                )
            );
          })
    );
  }

}



