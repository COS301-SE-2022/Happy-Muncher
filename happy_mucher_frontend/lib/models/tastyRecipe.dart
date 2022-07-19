class tastyRecipe {
  final String name;
  final String images;
  final int calories;
  final int recipeid;
  final int totTime;
  final String description;
  final List<String> ingredients;
  final List<String> instructions;
  tastyRecipe(
      {this.name = "",
      this.images = "",
      this.recipeid = 0,
      this.totTime = 0,
      this.description = "",
      this.ingredients = const [''],
      this.instructions = const [''],
      this.calories = 0});

  factory tastyRecipe.fromJson(dynamic data) {
    //calories @ [9] ???
    String nme = "";
    String img = "";
    int id = 0;
    int time = 0;
    String desc = '';
    List<String> steps = [];
    List<String> ing = [];
    int nutrition = 0;
    if (data['name'] != null) {
      nme = data['name'] as String;
    }
    if (data["thumbnail_url"] != null) {
      img = data["thumbnail_url"] as String;
    }
    if (data["id"] != null) {
      id = data["id"] as int;
    }
    if (data['total_time_minutes'] != null) {
      time = data['total_time_minutes'] as int;
    }
    else if (data['total_time_minutes'] != null){
      
    }
    if (data['description'] != null) {
      desc = data['description'] as String;
    }
    if (data['instructions'].length > 0) {
      for (var i in data['instructions']) {
        //print(i['wholeLine']);
        steps.add(i['display_text'] as String);
        //print(ing);
      }
    }
    if (data['sections'].length > 0) {
      for (var i in data['sections']) {
        for (var j in i['components']) {
          ing.add(j['raw_text']);
        }
      }
    }
    if (data['nutrition'].length > 0) {
      if(data['nutrition']['calories'] != null){
nutrition = data['nutrition']['calories'];
      }
      
    }

    return tastyRecipe(
        name: nme,
        images: img,
        recipeid: id,
        totTime: time,
        description: desc,
        instructions: steps,
        ingredients: ing,
        calories: nutrition);
  }
  static List<tastyRecipe> snapshotRecipes(List snapshot) {
    //return snapshot.map((dat) => Recipe.fromJson(dat)).toList();
    return snapshot.map((content) {
      return tastyRecipe.fromJson(content);
    }).toList();
  }

  @override
  String toString() {
    return 'Recipe {name: $name, image: $images, recipeId:$recipeid, time: $totTime, calories:$calories ,description: $description, ingredients:$ingredients, instructions:$instructions';
  }
}
