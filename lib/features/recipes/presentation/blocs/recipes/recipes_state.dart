part of 'recipes_bloc.dart';

enum RecipesStatus { initial, success, failure }

final class RecipesState extends Equatable {
  const RecipesState({
    this.status = RecipesStatus.initial,
    this.recipes = const <Recipe>[],
    this.total,
    this.hasReachedMax = false,
    this.errorMessage,
  });

  final RecipesStatus status;
  final List<Recipe> recipes;
  final int? total;
  final bool hasReachedMax;
  final String? errorMessage;

  RecipesState copyWith({
    RecipesStatus? status,
    List<Recipe>? recipes,
    int? total,
    bool? hasReachedMax,
    String? errorMessage,
  }) {
    return RecipesState(
      status: status ?? this.status,
      recipes: recipes ?? this.recipes,
      total: total ?? this.total,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, recipes, total, hasReachedMax, errorMessage];
}