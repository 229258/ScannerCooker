import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scanner_cooker/database/database.dart';
import 'package:scanner_cooker/spoonacular/models/recipe.dart';
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
  Color iconColor = Colors.transparent;

  List<RecipeDetails> list = [];

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
                            //Future<List<RecipeDetails>> recipes = GetRecipeByIngredients().getRecipe(ingredientsTextController.text.split(" "), int.parse(recipesCountTextController.text));
                            Future<List<RecipeDetails>> recipes = _getMockData();
                            recipes.then((value) {
                              setState(() {
                                titleTextHolder = value[0].title ?? "";
                                instructionsTextHolder = value[0].instructions ?? "";
                                recipeBackground = const Color.fromARGB(100, 255, 255, 255);
                                iconColor = Colors.black;
                                list = value;
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
                                      ),
                                      IconButton(onPressed: () {addData(list, 0, ingredientsTextController.text);}, icon: Icon(Icons.star), color: iconColor, tooltip: "Do you want to favorites recipes?")
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

  Future<List<RecipeDetails>>  _getMockData()
  {
    List<RecipeDetails> list = [];

    RecipeDetails x = RecipeDetails.fromJson(
          {
        "id": 1,
        "title":"Fries",
        "instructions": "Cut into bars. Fry in hot, deep fat"
        },
    );

    RecipeDetails y = RecipeDetails.fromJson(
      {
        "id": 2,
        "title":"Tomatoes",
        "instructions": "Cut tomatoes. Done"
      },
    );

    list.add(x);
    list.add(y);

    return Future.value(list);
  }

  void addData(List<RecipeDetails> list, int index, String products)
  {
    RecipeDetails recipe = RecipeDetails.fromJson(
        {
          "id": -1,
          "title": "",
          "instructions": ""
        }
        );

    try
    {
      recipe = list[index];
      Database.addItemFromModel(recipe, products);
    }on Exception catch (e)
    {
        _showMessage("Data could not be saved");
    }
    return;

  }

  static void _showMessage(String text)
  {
    Fluttertoast.showToast(msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
  }


}

