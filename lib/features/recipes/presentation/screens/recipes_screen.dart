
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jameia/core/config/responsive/screen_size.dart';
import 'package:jameia/core/config/theme/app_theme.dart';
import 'package:jameia/core/constants/app_strings.dart';
import 'package:jameia/core/constants/asset_paths.dart';
import 'package:jameia/core/presentation/cubits/theme_cubit/theme_cubit.dart';
import 'package:jameia/features/recipes/presentation/blocs/recipes/recipes_bloc.dart';
import 'package:jameia/features/recipes/presentation/widgets/bottom_loader.dart';
import 'package:jameia/features/recipes/presentation/widgets/error_display_widget.dart';
import 'package:jameia/features/recipes/presentation/widgets/recipe_list_item.dart';
import 'package:jameia/features/recipes/presentation/widgets/recipe_list_item_shimmer.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();
    final customTheme = Theme.of(context).extension<CustomThemeExtension>()!;

    return Scaffold(
      appBar: AppBar(
        title: ClipRRect(
  borderRadius: BorderRadius.circular(4), // You can adjust the radius
  child: Image(
    image: AssetImage(AssetPaths.appLogo),
    fit: BoxFit.cover,
    height: 40,
    width: 120,
  ),
),
centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(customTheme.themeToggleIcon),
            onPressed: () => themeCubit.toggleTheme(),
          ),
        ],
      ),
      body: BlocBuilder<RecipesBloc, RecipesState>(
        builder: (context, state) {
          switch (state.status) {
            case RecipesStatus.initial:
              return _buildShimmer(context);
            case RecipesStatus.failure:
              return ErrorDisplay(
                  message: state.errorMessage ?? 'An unknown error occurred.',
                  onRetry: () {
                    context.read<RecipesBloc>().add(RefreshRecipes());
                  });
            case RecipesStatus.success:
              if (state.recipes.isEmpty) {
                return const Center(child: Text(AppStrings.noRecipesFound));
              }
              return _buildRecipeLayout(context, state);
          }
        },
      ),
    );
  }
  
  Widget _buildShimmer(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return LayoutBuilder(builder: (context, constraints) {
          final bool isWide = !ScreenSize.isMobile(context);
          if (!isWide) {
            return ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) => const RecipeListItemShimmer(),
            );
          } else {
            final isLandscape = orientation == Orientation.landscape;
            final crossAxisCount = isLandscape ? 4 : 2;
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: isLandscape ? 1.1 : 0.8,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: crossAxisCount * 3,
              itemBuilder: (context, index) => const RecipeListItemShimmer(),
            );
          }
        });
      },
    );
  }

  Widget _buildRecipeLayout(BuildContext context, RecipesState state) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return LayoutBuilder(builder: (context, constraints) {
          final bool isWide = !ScreenSize.isMobile(context);

          if (!isWide) {
            // Mobile Layout: ListView
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              itemCount: state.hasReachedMax
                  ? state.recipes.length
                  : state.recipes.length + 1,
              controller: _scrollController,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: index >= state.recipes.length
                      ? const BottomLoader()
                      : RecipeListItem(recipe: state.recipes[index]),
                );
              },
            );
          } else {
            // Tablet/Desktop Layout: GridView
            final isLandscape = orientation == Orientation.landscape;
            final crossAxisCount = isLandscape ? 3 : 2;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: isLandscape ? 1.1 : 0.8,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              padding: const EdgeInsets.all(12),
              itemCount: state.hasReachedMax
                  ? state.recipes.length
                  : state.recipes.length + 1,
              controller: _scrollController,
              itemBuilder: (BuildContext context, int index) {
                return index >= state.recipes.length
                    ? const Center(child: BottomLoader())
                    : RecipeListItem(recipe: state.recipes[index]);
              },
            );
          }
        });
      },
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<RecipesBloc>().add(FetchRecipes());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
