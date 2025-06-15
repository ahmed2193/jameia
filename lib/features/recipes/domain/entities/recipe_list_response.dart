import 'package:equatable/equatable.dart';
import 'package:jameia/features/recipes/domain/entities/recipe.dart';

class RecipeListResponse extends Equatable {
  final List<Recipe> recipes;
  final int total;

  const RecipeListResponse({
    required this.recipes,
    required this.total,
  });

  @override
  List<Object?> get props => [recipes, total];
}
