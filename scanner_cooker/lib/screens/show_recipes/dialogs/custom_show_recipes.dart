import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../database/recipeItem.dart';
import '../../../utils/color_utils.dart';
import '../../../utils/custom_button.dart';

customShowDialog(Item recipe, BuildContext context)
{
  showDialog(
      context: context, builder: (context) {
    return Dialog(
      backgroundColor: stringToColorInHex("91e5f6"),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.close)),
              ),
              const Align(
                alignment: Alignment.topCenter,
                child: Text('Recipe details', style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(height: 10),
              const Text(
                  "Products"
              ),
              const SizedBox(height: 10),
              Text(
                  recipe.products
              ),
              const SizedBox(height: 10),
              const Text(
                  "Title"
              ),
              const SizedBox(height: 10),
              Text(
                  recipe.title ?? ''
              ),
              const SizedBox(height: 10),
              const Text(
                  "Recipe"
              ),
              const SizedBox(height: 10),
              Text(
                  recipe.recipe ?? ''
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      )

    );
  }
  );
}