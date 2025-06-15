import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jameia/features/recipes/domain/entities/recipe.dart';
import 'package:jameia/features/recipes/domain/usecases/get_recipe_details.dart';

part 'recipe_details_event.dart';
part 'recipe_details_state.dart';

class RecipeDetailsBloc extends Bloc<RecipeDetailsEvent, RecipeDetailsState> {
  final GetRecipeDetails getRecipeDetails;

  RecipeDetailsBloc({required this.getRecipeDetails})
      : super(RecipeDetailsInitial()) {
    on<FetchRecipeDetails>((event, emit) async {
      emit(RecipeDetailsLoading());
      final failureOrRecipe =
          await getRecipeDetails(GetRecipeDetailsParams(id: event.id));
      failureOrRecipe.fold(
        (failure) => emit(RecipeDetailsError(message: failure.message)),
        (recipe) => emit(RecipeDetailsLoaded(recipe: recipe)),
      );
    });
  }
}
