import 'package:dio/dio.dart';
import 'package:scanner_cooker/spoonacular/models/recipe_details.dart';
import 'models/info.dart';
import 'models/recipe.dart';
import 'models/recipe_details.dart';

const ingredientsRecipePath = '/findByIngredients?';
const informationRecipePath = '/information?';

class GetRecipeByIngredients {
  var apiKey = Info.keys;

  final dio = Dio();

  Future<List<RecipeDetails>> getRecipe(List<String> ingredients, int number) async {
    var url = '${Info.baseUrl}$ingredientsRecipePath&apiKey=$apiKey&number=$number';
    if (ingredients.isNotEmpty) {
      url += '&ingredients=';
      for (var element in ingredients) {
        url += '$element,';
      }
      url = url.substring(0, url.length - 1);
    }

    final result = await dio.get(url);

    List<int> recipesIds = [];

    if (result.statusCode == 200) {
      for (var i = 0; i < number; i++) {
        recipesIds.add(Recipe.fromJson(result.data[i]).id ?? -1);
      }
    } else {
      //TODO: implement proper error
      throw Error();
    }

    List<RecipeDetails> recipes = [];

    for (var element in recipesIds) {
      if (element != -1) {
        url = '${Info.baseUrl}$element${informationRecipePath}apiKey=$apiKey';

        final infoResult = await dio.get(url);
        if (infoResult.statusCode == 200) {
          var recipe = RecipeDetails.fromJson(infoResult.data);
          RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
          recipe.instructions = (recipe.instructions ?? "").replaceAll(exp, "");
          recipes.add(recipe);
        } else {
          //TODO: implement something?
        }
      }
    }

    return recipes;
  }

}