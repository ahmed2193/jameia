import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jameia/core/error/failures.dart';
import 'package:jameia/core/utils/usecases/usecase.dart';
import 'package:jameia/features/recipes/domain/entities/recipe.dart';
import 'package:jameia/features/recipes/domain/repositories/recipe_repository.dart';

class GetRecipeDetails implements UseCase<Recipe, GetRecipeDetailsParams> {
  final RecipeRepository repository;

  GetRecipeDetails(this.repository);

  @override
  Future<Either<Failure, Recipe>> call(GetRecipeDetailsParams params) async {
    return await repository.getRecipeDetails(params.id);
  }
}

class GetRecipeDetailsParams extends Equatable {
  final int id;

  const GetRecipeDetailsParams({required this.id});

  @override
  List<Object?> get props => [id];
}
