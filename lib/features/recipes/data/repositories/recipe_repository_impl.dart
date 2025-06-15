import 'package:dartz/dartz.dart';
import 'package:jameia/core/error/exceptions.dart';
import 'package:jameia/core/error/failures.dart';
import 'package:jameia/features/recipes/data/datasources/recipe_remote_datasource.dart';
import 'package:jameia/features/recipes/domain/entities/recipe.dart';
import 'package:jameia/features/recipes/domain/entities/recipe_list_response.dart';
import 'package:jameia/features/recipes/domain/repositories/recipe_repository.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDataSource remoteDataSource;

  RecipeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, RecipeListResponse>> getRecipes(int limit, int skip) async {
    try {
      final remoteRecipeResponse = await remoteDataSource.getRecipes(limit, skip);
      return Right(remoteRecipeResponse);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Unknown server error'));
    } on NoInternetConnectionException {
      return const Left(NetworkFailure('No internet connection'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Recipe>> getRecipeDetails(int id) async {
    try {
      final remoteRecipe = await remoteDataSource.getRecipeDetails(id);
      return Right(remoteRecipe);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Unknown server error'));
    } on NoInternetConnectionException {
      return const Left(NetworkFailure('No internet connection'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
