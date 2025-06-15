import 'package:dartz/dartz.dart';
import 'package:jameia/core/error/failures.dart';
import 'package:jameia/features/recipes/domain/entities/recipe.dart';
import 'package:jameia/features/recipes/domain/entities/recipe_list_response.dart';

abstract class RecipeRepository {
  Future<Either<Failure, RecipeListResponse>> getRecipes(int limit, int skip);
  Future<Either<Failure, Recipe>> getRecipeDetails(int id);
}