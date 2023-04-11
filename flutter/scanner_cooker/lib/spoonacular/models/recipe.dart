class Recipe{
  int? id;
  String? title;

  Recipe({
    this.id,
    this.title
  });

  factory Recipe.fromJson(json) => Recipe(
    id: json['id'] as int?,
    title: json['title'] as String?
  );

  toJson() => {
    'id': id,
    'title': title
  };
}