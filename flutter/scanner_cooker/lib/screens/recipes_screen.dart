import 'package:flutter/material.dart';
import 'package:scanner_cooker/utils/custom_button.dart';
import 'package:scanner_cooker/utils/textfield_widget.dart';
import '../spoonacular/get_recipe_from_ingredients.dart';
import '../spoonacular/models/recipe_details.dart';
import '../utils/color_utils.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  TextEditingController recipesCountTextController = TextEditingController();
  TextEditingController ingredientsTextController = TextEditingController();
  String titleTextHolder = "";
  String instructionsTextHolder = "";
  Color recipeBackground = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(color: stringToColorInHex("91e5f6")),
            child: SingleChildScrollView(
                child:Padding(
                    padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0.2, 20, 0),
                    child: Column(
                        children: <Widget>[
                          inputField(Icons.add, "How many recipies?", false, recipesCountTextController),
                          const SizedBox(height: 40),
                          inputField(Icons.add, "Ingredients list", false, ingredientsTextController),
                          const SizedBox(height: 40),
                          customButton(context, "Generate", () {
                            Future<List<RecipeDetails>> recipes = GetRecipeByIngredients().getRecipe(ingredientsTextController.text.split(" "), int.parse(recipesCountTextController.text));
                            recipes.then((value) {
                              setState(() {
                                titleTextHolder = value[0].title ?? "";
                                instructionsTextHolder = value[0].instructions ?? "";
                                recipeBackground = const Color.fromARGB(100, 255, 255, 255);
                              });
                              // List<Widget> items = [];
                              // for (var recipe in value) {
                              //   items.add(getRecipeItem(recipe));
                              // }
                            });
                          }),
                          const SizedBox(height: 40),
                          Card(
                              elevation: 0,
                              color: recipeBackground,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.all(32),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                          titleTextHolder,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Color.fromARGB(255, 75, 75, 75)),
                                          textAlign: TextAlign.center
                                      ),
                                      const SizedBox(height: 40),
                                      Text(
                                          instructionsTextHolder,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color.fromARGB(255, 75, 75, 75)),
                                          textAlign: TextAlign.center
                                      )
                                    ],
                                  )
                              )
                          ),
                          const SizedBox(height: 40)
                        ]
                    )
                )
            )
        )
    );
  }

  Column getRecipeItem(RecipeDetails details) {
    return Column(
        children: <Widget>[
          Text(details.title ?? ""),
          const SizedBox(height: 40),
          Text(details.instructions ?? "")
        ]
    );
  }
}

