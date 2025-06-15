import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:jameia/core/api/api_consumer.dart';
import 'package:jameia/core/api/app_interceptors.dart';
import 'package:jameia/core/api/dio_consumer.dart';
import 'package:jameia/core/presentation/cubits/theme_cubit/theme_cubit.dart';
import 'package:jameia/features/recipes/data/datasources/recipe_remote_datasource.dart';
import 'package:jameia/features/recipes/data/repositories/recipe_repository_impl.dart';
import 'package:jameia/features/recipes/domain/repositories/recipe_repository.dart';
import 'package:jameia/features/recipes/domain/usecases/get_recipe_details.dart';
import 'package:jameia/features/recipes/domain/usecases/get_recipes.dart';
import 'package:jameia/features/recipes/presentation/blocs/recipes/recipes_bloc.dart';
import 'package:jameia/features/recipes/presentation/blocs/recipes_details/recipe_details_bloc.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // #region Blocs / Cubits
  sl.registerFactory(() => ThemeCubit());
  sl.registerFactory(() => RecipesBloc(getRecipes: sl()));
  sl.registerFactory(() => RecipeDetailsBloc(getRecipeDetails: sl()));
  // #endregion

  // #region Usecases
  sl.registerLazySingleton(() => GetRecipes(sl()));
  sl.registerLazySingleton(() => GetRecipeDetails(sl()));
  // #endregion

  // #region Repositories
  sl.registerLazySingleton<RecipeRepository>(
      () => RecipeRepositoryImpl(remoteDataSource: sl()));
  // #endregion

  // #region Data Sources
  sl.registerLazySingleton<RecipeRemoteDataSource>(
      () => RecipeRemoteDataSourceImpl(apiConsumer: sl()));
  // #endregion

  // #region Core - API
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(client: sl()));
  sl.registerLazySingleton(() => AppIntercepters());
  sl.registerLazySingleton(() => LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true,
        error: true,
      ));
  sl.registerLazySingleton(() => Dio());
  // #endregion
}