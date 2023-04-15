import 'package:flutter/material.dart';
import 'package:scanner_cooker/utils/custom_button.dart';
import '../../../database/recipeItem.dart';
import '../../../utils/color_utils.dart';


TextField editTextField(TextEditingController controller, int size) {
  return TextField(
      maxLines: size,
      controller: controller,
      cursorColor: Colors.purple,
      style: TextStyle(color: Colors.black.withOpacity(0.9)),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
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

_setData(TextEditingController controller, String text)
{
  controller.value = TextEditingValue(
    text: text,
    selection: TextSelection.fromPosition(
      TextPosition(offset: text.length),
    ),
  );
}

customDialog(Item? recipe, String text, BuildContext context, Function(String?, String, String, String) logic)
{
  var productsController = TextEditingController();
  var recipeController = TextEditingController();
  var titleController = TextEditingController();

  if (recipe != null)
  {
      _setData(productsController, recipe.products);
      _setData(recipeController, recipe.recipe ?? '');
      _setData(titleController, recipe.title ?? '');
  }
  else
  {
  }

  showDialog(
      context: context, builder: (context) {
    return Dialog(
      backgroundColor: stringToColorInHex("91e5f6"),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.close)),
              ),
              const Text('Recipe details', style: TextStyle(fontSize: 20)),
              const SizedBox(height: 30),
              const Text(
                  "Products"
              ),
              const SizedBox(height: 10),
              editTextField(productsController, 1),
              const SizedBox(height: 10),
              const Text(
                  "Title"
              ),
              const SizedBox(height: 10),
              editTextField(titleController, 1),
              const SizedBox(height: 10),
              const Text(
                  "Recipe"
              ),
              const SizedBox(height: 10),
              editTextField(recipeController, 10),
              const SizedBox(height: 10),
              customButton(context, text, ()
              {
                //Database.editItem(recipe?.id, titleController.text.trim(), productsController.text.trim(), recipeController.text.trim());
                logic(recipe?.id, titleController.text.trim(), productsController.text.trim(), recipeController.text.trim());
                Navigator.pop(context);
              })
            ],
          ),
        ),
      )
    );
  }
  );
}