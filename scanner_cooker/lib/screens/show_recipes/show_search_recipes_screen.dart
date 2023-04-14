import 'package:flutter/material.dart';
import 'package:scanner_cooker/database/recipeItem.dart';
import 'dialogs/custom_show_recipes.dart';

String COLLECTION_USERS = "users";
String RECIPES = "recipes";

class ShowSearchRecipesScreen extends StatefulWidget {

  const ShowSearchRecipesScreen({Key? key, required this.recipes}) : super(key: key);

  final List<Item> recipes;

  @override
  State<ShowSearchRecipesScreen> createState() => _ShowSearchRecipesScreenState(recipes);
}

class _ShowSearchRecipesScreenState extends State<ShowSearchRecipesScreen>
{
  List<Item> search_recipes = [];

  _ShowSearchRecipesScreenState(List<Item> recipes)
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
                    subtitle: Text(search_recipes[index].title ?? ''),
                      onTap: () {customShowDialog(search_recipes[index], context);}
                  )
              );
            })
    );
  }
}




