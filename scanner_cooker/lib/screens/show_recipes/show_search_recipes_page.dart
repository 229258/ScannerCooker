import 'package:flutter/material.dart';
import '../../database/recipe.dart';

import '../../database/database.dart';

String COLLECTION_USERS = "users";
String RECIPES = "recipes";

class ShowSearchRecipesPage extends StatefulWidget {

  const ShowSearchRecipesPage({Key? key, required this.recipes}) : super(key: key);

  final List<Item> recipes;

  @override
  State<ShowSearchRecipesPage> createState() => _ShowSearchRecipesPageState(recipes);
}

class _ShowSearchRecipesPageState extends State<ShowSearchRecipesPage>
{

  List<Item> search_recipes = [];

  _ShowSearchRecipesPageState(List<Item> recipes)
  {
    search_recipes = recipes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("SEARCH RECIPIES"),
        ),
        body:
        ListView.builder(
            itemCount: search_recipes.length,
            itemBuilder: (context, index){
              return Card(
                  color: Colors.blue,
                  child: ListTile(
                    title: Text(search_recipes[index].products),
                    subtitle: Text(search_recipes[index].recipe ?? ''),
                      onTap: () {showRecipe(index);}
                  )
              );
            })
    );
  }

  showRecipe(index)
  {
    showDialog(
        context: context, builder: (context) {
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const Text('PRODUCTS'),
              Text(
                  search_recipes[index].products
              ),
                const Text('RECIPE'),
              Text(
                  search_recipes[index].recipe ?? ''
              ),
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: const Text("CLOSE"))
            ],
          ),
        ),
      );
    }
    );
  }


}




