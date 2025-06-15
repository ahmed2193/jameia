class EndPoints {
  static const String baseUrl = "https://dummyjson.com/";
  static const String recipes = "recipes";

  static String recipeDetails(int recipeId) => "recipes/$recipeId";
}
