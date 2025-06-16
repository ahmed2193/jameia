import 'package:jameia/core/api/api_consumer.dart';
import 'package:jameia/core/api/end_points.dart';
import 'package:jameia/features/recipes/data/models/recipe_list_response_model.dart';
import 'package:jameia/features/recipes/data/models/recipe_model.dart';

abstract class RecipeRemoteDataSource {
  Future<RecipeListResponseModel> getRecipes(int limit, int skip);
  Future<RecipeModel> getRecipeDetails(int id);
}

class RecipeRemoteDataSourceImpl implements RecipeRemoteDataSource {
  final ApiConsumer apiConsumer;

  RecipeRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<RecipeListResponseModel> getRecipes(int limit, int skip) async {
    final response = await apiConsumer.get(
      EndPoints.recipes,
      queryParameters: {'limit': limit, 'skip': skip},
    );
    return RecipeListResponseModel.fromJson(response);
  }

  @override
  Future<RecipeModel> getRecipeDetails(int id) async {
    final response = await apiConsumer.get(EndPoints.recipeDetails(id));
    return RecipeModel.fromJson(response);
  }
}