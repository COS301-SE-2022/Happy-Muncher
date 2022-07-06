class Recipe {
  final String name;
  final String images;
  final double rating;
  final String totalTime;
  Recipe(
      {this.name = "", this.images = "", this.rating = 0, this.totalTime = ""});

  factory Recipe.fromJson(dynamic data) {
    try {
      if (data['name'] != null &&
          data['images'][0]["hostedLargeUrl"] != null &&
          data['rating'] != null &&
          data['totalTime'] != null) {
        return Recipe(
            name: data["name"] as String,
            images: data['images'][0]["hostedLargeUrl"] as String,
            rating: data['rating'] as double,
            totalTime: data['totalTime'] as String);
      } else {}
    } catch (e) {
      print("Error");
    }
    print("fetching nulls here");
    return Recipe(
        name: "" as String,
        images: "" as String,
        rating: 0.0 as double,
        totalTime: 'totaltime' as String);
  }
  static List<Recipe> snapshotRecipes(List snapshot) {
    //return snapshot.map((dat) => Recipe.fromJson(dat)).toList();
    return snapshot.map((content) {
      return Recipe.fromJson(content);
    }).toList();
  }

  @override
  String toString() {
    return 'Recipe {name: $name, image: $images, rating:$rating, totalTime:$totalTime';
  }
}
