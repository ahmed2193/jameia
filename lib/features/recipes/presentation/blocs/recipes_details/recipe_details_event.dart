part of 'recipe_details_bloc.dart';

abstract class RecipeDetailsEvent extends Equatable {
  const RecipeDetailsEvent();

  @override
  List<Object> get props => [];
}

class FetchRecipeDetails extends RecipeDetailsEvent {
  final int id;

  const FetchRecipeDetails({required this.id});

  @override
  List<Object> get props => [id];
}
