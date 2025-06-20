part of 'recipes_bloc.dart';

abstract class RecipesEvent extends Equatable {
  const RecipesEvent();

  @override
  List<Object> get props => [];
}

class FetchRecipes extends RecipesEvent {}

class RefreshRecipes extends RecipesEvent {}