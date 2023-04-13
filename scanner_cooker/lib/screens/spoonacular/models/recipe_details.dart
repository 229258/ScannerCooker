class RecipeDetails {
  int? id;
  String? title;
  String? instructions;

  RecipeDetails({
    this.id,
    this.title,
    this.instructions
  });

  factory RecipeDetails.fromJson(json) => RecipeDetails(
      id: json['id'] as int?,
      title: json['title'] as String?,
      instructions: json['instructions'] as String?
  );

  toJson() => {
    'id': id,
    'title': title,
    'instructions': instructions
  };
}