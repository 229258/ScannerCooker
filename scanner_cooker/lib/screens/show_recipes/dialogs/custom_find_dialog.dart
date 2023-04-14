import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scanner_cooker/screens/show_recipes/show_search_recipes_screen.dart';
import 'package:scanner_cooker/utils/custom_button.dart';
import '../../../database/database.dart';
import '../../../database/recipeItem.dart';
import '../../../utils/color_utils.dart';

searchDialog(BuildContext context, List<Item> recipeItems)
{
  var searchController = TextEditingController();

  showDialog(
      context: context, builder: (context) {
    return AlertDialog(
      backgroundColor: stringToColorInHex("91e5f6"),
        content: Column(
            mainAxisSize: MainAxisSize.min,
          children: [
            const Text('What are you looking for. Write products'),
            TextField(
              controller: searchController,
            ),
            customButton(context, "FIND", ()
            {
              var text = searchController.text.trim();
              List<Item> ans = [];

              if (text != null)
              {
                ans = Database.searchItem(text, recipeItems);
              }

              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => ShowSearchRecipesScreen(recipes: ans)));
            })
          ],
        ),
      );
  }
  );
}