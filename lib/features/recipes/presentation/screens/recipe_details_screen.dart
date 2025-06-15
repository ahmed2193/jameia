import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jameia/core/config/responsive/screen_size.dart';
import 'package:jameia/core/constants/app_strings.dart';
import 'package:jameia/core/di/service_locator.dart';
import 'package:jameia/features/recipes/domain/entities/recipe.dart';
import 'package:jameia/features/recipes/presentation/blocs/recipes_details/recipe_details_bloc.dart';
import 'package:jameia/features/recipes/presentation/widgets/error_display_widget.dart';
import 'package:jameia/features/recipes/presentation/widgets/recipe_details_shimmer.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailsScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  bool _isAppBarCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<RecipeDetailsBloc>()..add(FetchRecipeDetails(id: widget.recipe.id)),
      child: Scaffold(
        body: OrientationBuilder(builder: (context, orientation) {
          return BlocBuilder<RecipeDetailsBloc, RecipeDetailsState>(
            builder: (context, state) {
              if (state is RecipeDetailsInitial ||
                  state is RecipeDetailsLoading) {
                return _buildRecipeDetails(context, widget.recipe, orientation,
                    isShimmerLoading: true);
              }
              if (state is RecipeDetailsLoaded) {
                return _buildRecipeDetails(context, state.recipe, orientation);
              }
              if (state is RecipeDetailsError) {
                return ErrorDisplay(
                  message: state.message,
                  onRetry: () {
                    context
                        .read<RecipeDetailsBloc>()
                        .add(FetchRecipeDetails(id: widget.recipe.id));
                  },
                );
              }
              return const SizedBox.shrink();
            },
          );
        }),
      ),
    );
  }

  Widget _buildRecipeDetails(BuildContext context, Recipe detailedRecipe,
      Orientation orientation,
      {bool isShimmerLoading = false}) {
    final textTheme = Theme.of(context).textTheme;
    final isLandscape = orientation == Orientation.landscape;

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        final expandedHeight = isLandscape ? 180.0 : 300.0;
        final collapsedThreshold = expandedHeight - kToolbarHeight;
        
        if (scrollNotification is ScrollUpdateNotification) {
          final isCollapsed = scrollNotification.metrics.pixels > collapsedThreshold;
          if (isCollapsed != _isAppBarCollapsed) {
            setState(() {
              _isAppBarCollapsed = isCollapsed;
            });
          }
        }
        return false;
      },
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            stretch: true,
            expandedHeight: isLandscape ? 180.0 : 300.0,
            pinned: true,
            // Custom leading widget with iOS back arrow
            leading: Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: _isAppBarCollapsed ? Colors.transparent : Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: _isAppBarCollapsed 
                        ? Theme.of(context).colorScheme.onSurface 
                        : Colors.white,
                    size: 20,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          flexibleSpace: FlexibleSpaceBar(
            titlePadding:
                const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
            centerTitle: true,
            title: Text(
              detailedRecipe.name,
              style: textTheme.titleLarge?.copyWith(
                color: Colors.white,
                shadows: [
                  const Shadow(
                      blurRadius: 4.0,
                      color: Colors.black54,
                      offset: Offset(2, 2))
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            background: Hero(
              tag: 'recipe_image_${detailedRecipe.id}',
              child: CachedNetworkImage(
                imageUrl: detailedRecipe.image,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Container(color: Colors.grey[300]),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: isShimmerLoading
                  ? const RecipeDetailsShimmer()
                  : _buildContent(context, detailedRecipe, orientation),
            ),
          ),
        )
      ],
    ));
  }

  Widget _buildContent(
      BuildContext context, Recipe detailedRecipe, Orientation orientation) {
    final bool isWideLandscape =
        orientation == Orientation.landscape && !ScreenSize.isMobile(context);

    if (isWideLandscape) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: _buildIngredientsColumn(context, detailedRecipe),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child: _buildInstructionsColumn(context, detailedRecipe),
              ),
            ),
          ],
        ),
      
    );
    } else {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIngredientsColumn(context, detailedRecipe),
            const SizedBox(height: 24),
            _buildInstructionsColumn(context, detailedRecipe),
          ],
        ),
      );
    }
  }

  Widget _buildIngredientsColumn(BuildContext context, Recipe recipe) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildInfoRow(context, recipe),
        const SizedBox(height: 24),
        if (recipe.ingredients != null && recipe.ingredients!.isNotEmpty)
          _buildSectionTitle(context, AppStrings.ingredients),
        if (recipe.ingredients != null)
          ...recipe.ingredients!
              .map((item) => _buildListItem(context, item))
              .toList(),
      ],
    );
  }

  Widget _buildInstructionsColumn(BuildContext context, Recipe recipe) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (recipe.instructions != null && recipe.instructions!.isNotEmpty)
          _buildSectionTitle(context, AppStrings.instructions),
        if (recipe.instructions != null)
          ...recipe.instructions!
              .asMap()
              .entries
              .map((entry) =>
                  _buildInstructionItem(context, entry.key + 1, entry.value))
              .toList(),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, Recipe recipe) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        if (recipe.prepTimeMinutes != null)
          _buildInfoChip(Icons.timer_outlined, '${recipe.prepTimeMinutes} min',
              AppStrings.prepTime),
        if (recipe.cookTimeMinutes != null)
          _buildInfoChip(Icons.whatshot_outlined,
              '${recipe.cookTimeMinutes} min', AppStrings.cookTime),
        if (recipe.servings != null)
          _buildInfoChip(
              Icons.people_outline, '${recipe.servings}', AppStrings.servings),
        if (recipe.difficulty != null)
          _buildInfoChip(Icons.star_border_outlined, '${recipe.difficulty}',
              AppStrings.difficulty),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String label, String subLabel) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          children: [
            Icon(icon, size: 28),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(subLabel, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }

  Widget _buildListItem(BuildContext context, String item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6.0, right: 8.0),
            child: Icon(Icons.check_circle_outline,
                size: 16, color: Theme.of(context).colorScheme.secondary),
          ),
          Expanded(
            child: Text(
              item,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionItem(
      BuildContext context, int step, String instruction) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            child: Text('$step'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              instruction,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}