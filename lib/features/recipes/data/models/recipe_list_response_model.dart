import 'package:jameia/features/recipes/data/models/recipe_model.dart';
import 'package:jameia/features/recipes/domain/entities/recipe_list_response.dart';

class RecipeListResponseModel extends RecipeListResponse {
  const RecipeListResponseModel({
    required super.recipes,
    required super.total,
  });

  factory RecipeListResponseModel.fromJson(Map<String, dynamic> json) {
    return RecipeListResponseModel(
      recipes: List<RecipeModel>.from(
          (json['recipes'] as List).map((x) => RecipeModel.fromJson(x))),
      total: json['total'],
    );
  }
}