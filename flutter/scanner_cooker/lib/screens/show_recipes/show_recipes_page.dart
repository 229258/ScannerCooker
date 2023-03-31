import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scanner_cooker/database/recipe.dart';

import '../../database/database.dart';


class ShowRecipesPage extends StatefulWidget {
  const ShowRecipesPage({Key? key}) : super(key: key);

  @override
  State<ShowRecipesPage> createState() => _ShowRecipesPageState();
}

class _ShowRecipesPageState extends State<ShowRecipesPage>
{
  List<Item> recipeItems = [];
  String user = FirebaseAuth.instance.currentUser!.uid;
  Database d = Database(FirebaseAuth.instance.currentUser!.uid);

  @override
  void initState()
  {
    fetchRecords();
    FirebaseFirestore.instance.collection("users").doc(user).collection("/recipes").snapshots().listen((records) {
      mapRecords(records);
    });

    super.initState();
  }

  fetchRecords() async {
    var records = await FirebaseFirestore.instance
        .collection("users")
        .doc(user)
        .collection("/recipes")
        .get();

    mapRecords(records);
  }

  mapRecords(QuerySnapshot<Map<String, dynamic>> records)
  {
    var _list = records.docs.map((item) => Item(
        id: item.id,
        products: item['products'],
        recipe: item['recipe']),
    ).toList();

    setState(() {
      recipeItems = _list;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            IconButton(
                onPressed: showItemDialog,
                icon: const Icon(Icons.add))
          ]
      ),
      body: ListView.builder(
          itemCount: recipeItems.length,
          itemBuilder: (context, index){
            return Slidable(
                endActionPane: ActionPane(
                  motion: ScrollMotion(),
                  children: [
                    SlidableAction(
                        onPressed: (c){
                          d.deleteItem(recipeItems[index].id);
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                        spacing: 8
                    )
                  ],

                ),
                child: ListTile(
                  title: Text(recipeItems[index].products),
                  subtitle: Text(recipeItems[index].recipe ?? ''),
                )
            );
          }),
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
                var ans = d.addItem(products, recipe);

                if (!ans)
                {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("product not entered"),
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
}



