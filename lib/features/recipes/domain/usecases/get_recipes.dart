import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jameia/core/error/failures.dart';
import 'package:jameia/core/utils/usecases/usecase.dart';
import 'package:jameia/features/recipes/domain/entities/recipe_list_response.dart';
import 'package:jameia/features/recipes/domain/repositories/recipe_repository.dart';

class GetRecipes implements UseCase<RecipeListResponse, GetRecipesParams> {
  final RecipeRepository repository;

  GetRecipes(this.repository);

  @override
  Future<Either<Failure, RecipeListResponse>> call(GetRecipesParams params) async {
    return await repository.getRecipes(params.limit, params.skip);
  }
}

class GetRecipesParams extends Equatable {
  final int limit;
  final int skip;

  const GetRecipesParams({required this.limit, required this.skip});

  @override
  List<Object?> get props => [limit, skip];
}