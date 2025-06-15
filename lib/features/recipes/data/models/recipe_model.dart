import 'package:jameia/features/recipes/domain/entities/recipe.dart';

class RecipeModel extends Recipe {
  const RecipeModel({
    required super.id,
    required super.name,
    required super.image,
    super.ingredients,
    super.instructions,
    super.prepTimeMinutes,
    super.cookTimeMinutes,
    super.servings,
    super.difficulty,
    super.cuisine,
    super.caloriesPerServing,
    super.tags,
    super.rating,
    super.reviewCount,
    super.mealType,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      ingredients: json['ingredients'] != null
          ? List<String>.from(json['ingredients'].map((x) => x))
          : null,
      instructions: json['instructions'] != null
          ? List<String>.from(json['instructions'].map((x) => x))
          : null,
      prepTimeMinutes: json['prepTimeMinutes'],
      cookTimeMinutes: json['cookTimeMinutes'],
      servings: json['servings'],
      difficulty: json['difficulty'],
      cuisine: json['cuisine'],
      caloriesPerServing: json['caloriesPerServing'],
      tags: json['tags'] != null
          ? List<String>.from(json['tags'].map((x) => x))
          : null,
      rating: json['rating']?.toDouble(),
      reviewCount: json['reviewCount'],
      mealType: json['mealType'] != null
          ? List<String>.from(json['mealType'].map((x) => x))
          : null,
    );
  }
}
