import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scanner_cooker/utils/custom_button.dart';
import 'barcode/barcode_scanner_screen.dart';
import '../spoonacular/get_recipe_from_ingredients.dart';
import '../spoonacular/models/recipe_details.dart';
import '../utils/color_utils.dart';
import 'package:scanner_cooker/database/database.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  TextEditingController recipesCountTextController = TextEditingController();
  TextEditingController ingredientsTextController = TextEditingController();
  List<RecipeDetails> recipesListViewItems = [];
  Color recipeBackground = Colors.transparent;
  String products = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(color: stringToColorInHex("91e5f6")),
            child: SingleChildScrollView(
                child:Padding(
                    padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0.1, 20, 0),
                    child: Column(
                        children: <Widget>[
                          SizedBox(
                            child: customButton(
                                context,
                                'SCAN BARCODES',
                                () => _addIngredientsFromBarcodes(context),
                                0.6
                          )),
                          getRecipesCountTextField(),
                          const SizedBox(height: 40),
                          getIngredientsTextField(),
                          const SizedBox(height: 40),
                          customButton(context, "Generate", () {
                            Future<List<RecipeDetails>> recipes = GetRecipeByIngredients().getRecipe(ingredientsTextController.text.split(" "), int.tryParse(recipesCountTextController.text));
                            recipes.catchError((e){
                              Fluttertoast.showToast(
                                  msg: "Error: ${e.toString()}",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                            }).then((value) {
                              setState(() {
                                recipesListViewItems = value;
                                recipeBackground = const Color.fromARGB(100, 255, 255, 255);
                                products = ingredientsTextController.text;
                              });
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
                                      ListView.builder(
                                        physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: recipesListViewItems.length,
                                        itemBuilder: (ctx, i) {
                                          return getRecipeItem(recipesListViewItems[i], i);
                                        },
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

  Future<void> _addIngredientsFromBarcodes(BuildContext context) async {
    List<String> barcodeIngredients = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BarcodeScannerScreen()));

    ingredientsTextController.text = "${ingredientsTextController.text} ${barcodeIngredients.join(" ")}";
  }

  Column getRecipeItem(RecipeDetails details, int index) {
    var firstEmptySpace = const SizedBox(height: 80);
    if (index == 0) {
      firstEmptySpace = const SizedBox(height: 0);
    }
    return Column(children: <Widget>[
      firstEmptySpace,
      Align(
        alignment: Alignment.topRight,
        child: IconButton(icon: Icon(Icons.star_border), onPressed: () { addData(details); },)
      ),

      Text(details.title ?? "",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Color.fromARGB(255, 75, 75, 75)),
          textAlign: TextAlign.center),
      const SizedBox(height: 40),
      Text(details.instructions ?? "",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color.fromARGB(255, 75, 75, 75)),
          textAlign: TextAlign.center)
    ]);
  }

  TextField getRecipesCountTextField() {
    return TextField(
        controller: recipesCountTextController,
        cursorColor: Colors.purple,
        style: TextStyle(color: Colors.black.withOpacity(0.9)),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          prefixIcon: const Icon(
              Icons.add,
              color: Colors.black
          ),
          labelText: "How many recipes? (max: 3)",
          labelStyle: TextStyle(color: Colors.black.withOpacity(0.9)),
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          fillColor: Colors.white.withOpacity(0.4),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: const BorderSide(width: 0, style: BorderStyle.none)
          ),
        )
    );
  }
  TextField getIngredientsTextField() {
    return TextField(
        controller: ingredientsTextController,
        cursorColor: Colors.purple,
        style: TextStyle(color: Colors.black.withOpacity(0.9)),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          prefixIcon: const Icon(
              Icons.add,
              color: Colors.black
          ),
          labelText: "Ingredients list",
          labelStyle: TextStyle(color: Colors.black.withOpacity(0.9)),
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          fillColor: Colors.white.withOpacity(0.4),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: const BorderSide(width: 0, style: BorderStyle.none)
          ),
        )
    );
  }

  void addData(RecipeDetails recipe)
  {
    try
    {
      Database.addItemFromModel(recipe, products);
      _showMessage("Recipe added");
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

