class Recipe {
  final String name;
  final String images;
  final double calories;
  final String totalTime;
  final String description;
  final List<String> ingredients;
  Recipe({
    this.name = "",
    this.images = "",
    this.calories = 0,
    this.totalTime = "",
    this.description = "",
    this.ingredients = const [""],
  });

  factory Recipe.fromJson(dynamic data) {
    //calories @ [9] ???
    String nme = "";
    String img = "";
    double cal = 0.0;
    String tt = "";
    String desc = "";
    List<String> ing = [];
    if (data['details']["name"] != null) {
      nme = data['details']["name"] as String;
      desc = "Just " + nme;
    }
    if (data['details']['images'][0]["hostedLargeUrl"] != null) {
      img = data['details']['images'][0]["hostedLargeUrl"] as String;
    }
    if (data['nutrition']['nutritionEstimates'].length > 0) {
      if (data['nutrition']['nutritionEstimates'][1]['value'] != null) {
        cal = data['nutrition']['nutritionEstimates'][1]['value'] as double;
      }
    }
    if (data['details']['totalTime'] != null) {
      tt = data['details']['totalTime'] as String;
    }
    if (data['description'] != null) {
      if (data['description']['text'] != null) {
        desc = data['description']['text'] as String;
      }
    }
    if (data['ingredientLines'].length > 0) {
      for (var i in data['ingredientLines']) {
        //print(i['wholeLine']);
        ing.add(i['wholeLine'] as String);
        //print(ing);
      }
    }
    return Recipe(
        name: nme,
        images: img,
        calories: cal,
        totalTime: tt,
        description: desc,
        ingredients: ing);
  }
  static List<Recipe> snapshotRecipes(List snapshot) {
    //return snapshot.map((dat) => Recipe.fromJson(dat)).toList();
    return snapshot.map((content) {
      return Recipe.fromJson(content);
    }).toList();
  }

  @override
  String toString() {
    return 'Recipe {name: $name, image: $images, rating:$calories, totalTime:$totalTime, description:$description, ingredients: $ingredients';
  }
}
