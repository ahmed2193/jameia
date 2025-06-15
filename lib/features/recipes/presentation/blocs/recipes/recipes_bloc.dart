import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jameia/features/recipes/domain/entities/recipe.dart';
import 'package:jameia/features/recipes/domain/entities/recipe_list_response.dart';
import 'package:jameia/features/recipes/domain/usecases/get_recipes.dart';
import 'dart:async';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:stream_transform/stream_transform.dart';

part 'recipes_event.dart';
part 'recipes_state.dart';

const _limit = 15;
const _throttleDuration = Duration(milliseconds: 200);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class RecipesBloc extends Bloc<RecipesEvent, RecipesState> {
  final GetRecipes getRecipes;

  RecipesBloc({required this.getRecipes}) : super(const RecipesState()) {
    on<FetchRecipes>(
      _onFetchRecipes,
      transformer: throttleDroppable(_throttleDuration),
    );
     on<RefreshRecipes>(_onRefreshRecipes);
  }
  
  Future<void> _onRefreshRecipes(
      RefreshRecipes event, Emitter<RecipesState> emit) async {
    emit(const RecipesState());
    await _onFetchRecipes(FetchRecipes(), emit);
  }

  Future<void> _onFetchRecipes(
      FetchRecipes event, Emitter<RecipesState> emit) async {
        
    if (state.hasReachedMax) return;

    try {
      if (state.status == RecipesStatus.initial) {
        final response = await _fetchRecipes();
        return emit(state.copyWith(
          status: RecipesStatus.success,
          recipes: response.recipes,
          total: response.total,
          hasReachedMax: response.recipes.length >= response.total,
        ));
      }
log(state.recipes.length.toString());
      // Fetch more recipes
      final response = await _fetchRecipes(state.recipes.length);
      log(state.recipes.length.toString());

      final newRecipes = List.of(state.recipes)..addAll(response.recipes);
      
      emit(response.recipes.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: RecipesStatus.success,
              recipes: newRecipes,
              total: response.total,
              hasReachedMax: newRecipes.length >= response.total,
            ));
    } catch (e) {
      emit(state.copyWith(
          status: RecipesStatus.failure,
          errorMessage: e.toString().replaceFirst("Exception: ", "")));
    }
  }

  Future<RecipeListResponse> _fetchRecipes([int skip = 0]) async {
    final result = await getRecipes(GetRecipesParams(limit: _limit, skip: skip));
    return result.fold(
      (failure) => throw Exception(failure.message),
      (response) => response,
    );
  }
}
