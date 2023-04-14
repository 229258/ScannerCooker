import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../database/recipe.dart';
import 'package:scanner_cooker/screens/show_recipes/show_search_recipes_page.dart';

import '../../database/database.dart';

String COLLECTION_USERS = "users";
String RECIPES = "recipes";

class ShowRecipesPage extends StatefulWidget {
  const ShowRecipesPage({Key? key}) : super(key: key);

  @override
  State<ShowRecipesPage> createState() => _ShowRecipesPageState();
}

class _ShowRecipesPageState extends State<ShowRecipesPage>
{
  List<Item> recipeItems = [];
  List<Item> tmpRecipeItems = [];
  String user = FirebaseAuth.instance.currentUser!.uid;
  bool connectInternet = true;


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
          connectInternet = connect();
        });
      }
      //recipeItems = [];
    }).onError((e)=>print(e.toString()));
  }

  bool connect()
  {
    bool res = false;
    var subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none)
      {
        res =  false;
      }
      else
      {
        res =  true;
      }
    }).onError((error, s) =>({
      res = false
    }));

    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("FAVORITES RECIPIES"),
          actions: [
            IconButton(
                onPressed: (){searchBar();},
                icon: const Icon(Icons.search)
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(child: Icon(Icons.add), onPressed: showItemDialog,),
        body:
        ListView.builder(
            itemCount: recipeItems.length,
            itemBuilder: (context, index){
              return Card(
                  color: Colors.blue,
                  child: ListTile(
                      leading: IconButton(onPressed: () { editItemDialog(index); }, icon: Icon(Icons.edit),),
                      trailing: IconButton(onPressed: () { Database.deleteItem(recipeItems[index].id); }, icon: Icon(Icons.delete),),
                      title: Text(recipeItems[index].products),
                      subtitle: Text(recipeItems[index].recipe ?? ''),
                      onTap: () {
                        print("tapped");
                      }
                  )
              );
            })
    );
  }
  showItemDialog()
  {
    var productsController = TextEditingController();
    var recipeController = TextEditingController();

    showDialog(
        context: context, builder: (context) {
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text('Item details'),
              TextField(
                controller: productsController,
              ),
              TextField(
                controller: recipeController,
              ),
              TextButton(onPressed: (){
                var products = productsController.text.trim();
                var recipe = recipeController.text.trim();

                var ans = Database.addItem(products, recipe);

                if (!ans)
                {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Product not entered"),
                  ));
                }
                Navigator.pop(context);
              }, child: const Text("Add"))
            ],
          ),
        ),
      );
    }
    );
  }

  editItemDialog(index)
  {
    var recipeController = TextEditingController();
    var value = recipeItems[index].recipe ?? '';

    recipeController.value = TextEditingValue(
      text: value,
      selection: TextSelection.fromPosition(
        TextPosition(offset: value.length),
      ),
    );

    showDialog(
        context: context, builder: (context) {
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text('Item details'),
              Text(
                  recipeItems[index].products
              ),
              TextField(
                  controller: recipeController,
                  showCursor: true
              ),
              TextButton(onPressed: (){
                var ans = false;
                var recipe = recipeController.text.trim();
                try
                {
                  ans = Database.editItem(recipeItems[index].id, recipe);
                }on Exception {
                  ans = false;
                }

                if (!ans)
                {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Recipe don't edit"),
                  ));
                }
                Navigator.pop(context);
              }, child: const Text("Edit"))
            ],
          ),
        ),
      );
    }
    );
  }

  searchBar()
  {
    var searchController = TextEditingController();

    showDialog(
        context: context, builder: (context) {
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text('What are you looking for'),
              TextField(
                controller: searchController,
              ),
              TextButton(onPressed: (){
                var text = searchController.text.trim();
                List<Item> ans = [];

                if (text != null)
                {
                  ans = Database.searchItem(text, recipeItems);
                }

                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => ShowSearchRecipesPage(recipes: ans)));
              }, child: const Text("FIND"))
            ],
          ),
        ),
      );
    }
    );
  }
}