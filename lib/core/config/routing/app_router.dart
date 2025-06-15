import 'package:flutter/material.dart';
import 'package:jameia/features/recipes/domain/entities/recipe.dart';
import 'package:jameia/features/recipes/presentation/screens/recipes_screen.dart';
import 'package:jameia/features/recipes/presentation/screens/recipe_details_screen.dart';
import 'package:jameia/core/constants/app_strings.dart';

class AppRouter {
  static const String homeRoute = '/';
  static const String recipeDetailsRoute = '/recipe-details';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => const RecipesScreen());
      case recipeDetailsRoute:
        final recipe = settings.arguments as Recipe?;
        if (recipe != null) {
          return MaterialPageRoute(
            builder: (_) => RecipeDetailsScreen(recipe: recipe),
          );
        }
        return _errorRoute(settings);
      default:
        return _errorRoute(settings);
    }
  }

  static Route<dynamic> _errorRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text(AppStrings.routeNotFound)),
        body: Center(
          child: Text('${AppStrings.routeNotFound}: ${settings.name}'),
        ),
      ),
    );
  }
}
