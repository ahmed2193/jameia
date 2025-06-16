import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jameia/core/config/routing/app_router.dart';
import 'package:jameia/features/recipes/domain/entities/recipe.dart';

class RecipeListItem extends StatefulWidget {
  const RecipeListItem({super.key, required this.recipe});

  final Recipe recipe;

  @override
  State<RecipeListItem> createState() => _RecipeListItemState();
}

class _RecipeListItemState extends State<RecipeListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Helper method to get difficulty color and icon
  Map<String, dynamic> getDifficultyStyle(String? difficulty) {
    switch (difficulty?.toLowerCase()) {
      case 'easy':
        return {
          'color': Colors.green,
          'icon': Icons.star_outline_rounded,
          'label': 'Easy'
        };
      case 'medium':
        return {
          'color': Colors.orange,
          'icon': Icons.star_half_rounded,
          'label': 'Medium'
        };
      case 'hard':
      case 'heard': // Handle typo in your example
        return {
          'color': Colors.red,
          'icon': Icons.star_rounded,
          'label': 'Hard'
        };
      default:
        return {
          'color': Colors.green,
          'icon': Icons.star_outline_rounded,
          'label': 'Easy'
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;
    final isTablet = screenWidth > 600;
    
    // Responsive sizing based on orientation and screen size
    final cardHeight = isLandscape 
        ? (isTablet ? 200.0 : 160.0) 
        : (isTablet ? 280.0 : 220.0);
    
    final difficultyStyle = getDifficultyStyle(widget.recipe.difficulty);
    
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            height: cardHeight,
            margin: EdgeInsets.symmetric(
              horizontal: isTablet ? 12.0 : 8.0,
              vertical: 8.0,
            ),
            child: Card(
              elevation: _isPressed ? 2 : 8,
              shadowColor: Colors.black.withOpacity(0.3),
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: GestureDetector(
                onTapDown: (_) {
                  setState(() => _isPressed = true);
                  _animationController.forward();
                },
                onTapUp: (_) {
                  setState(() => _isPressed = false);
                  _animationController.reverse();
                },
                onTapCancel: () {
                  setState(() => _isPressed = false);
                  _animationController.reverse();
                },
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRouter.recipeDetailsRoute,
                    arguments: widget.recipe,
                  );
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background Image with Hero Animation
                    Hero(
                      tag: 'recipe_image_${widget.recipe.id}',
                      child: CachedNetworkImage(
                        imageUrl: widget.recipe.image,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Theme.of(context).colorScheme.surfaceContainerHighest,
                                Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
                              ],
                            ),
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Theme.of(context).colorScheme.errorContainer,
                                Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.7),
                              ],
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.restaurant_menu_rounded,
                                size: isTablet ? 48 : 40,
                                color: Theme.of(context).colorScheme.onErrorContainer,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Image not available',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onErrorContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    // Gradient Overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.1),
                            Colors.black.withValues(alpha: 0.7),
                            Colors.black.withValues(alpha: 0.9),
                          ],
                          stops: const [0.0, 0.4, 0.8, 1.0],
                        ),
                      ),
                    ),
                    
                    // Content Container
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: EdgeInsets.all(isTablet ? 20.0 : 16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Recipe Name
                            Text(
                              widget.recipe.name,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: isLandscape 
                                    ? (isTablet ? 20 : 16) 
                                    : (isTablet ? 24 : 20),
                                shadows: [
                                  const Shadow(
                                    blurRadius: 4.0,
                                    color: Colors.black54,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                                letterSpacing: 0.5,
                              ),
                              maxLines: isLandscape ? 1 : 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            
                            SizedBox(height: isLandscape ? 4 : 8),
                            
                            // Recipe Metadata Row - Responsive layout
                            isLandscape 
                                ? _buildLandscapeMetadataLayout(context, difficultyStyle, isTablet)
                                : _buildPortraitMetadataLayout(context, difficultyStyle, isTablet),
                          ],
                        ),
                      ),
                    ),
                    
                    // Subtle shine effect on press
                    if (_isPressed)
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withValues(alpha: 0.1),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Portrait layout (original layout)
  Widget _buildPortraitMetadataLayout(BuildContext context, Map<String, dynamic> difficultyStyle, bool isTablet) {
    return Row(
      children: [
        // Time badge
        _buildTimeBadge(context, isTablet, false),
        const SizedBox(width: 8),
        
        // Difficulty badge with color coding
        _buildDifficultyBadge(context, difficultyStyle, isTablet, false),
        const SizedBox(width: 8),
        
        // Rating badge
        if (widget.recipe.rating != null) ...[
          _buildRatingBadge(context, isTablet, false),
        ],
        
        const Spacer(),
        
        // Favorite Icon
        _buildFavoriteIcon(context, isTablet, false),
      ],
    );
  }

  // Landscape layout - more compact and responsive
  Widget _buildLandscapeMetadataLayout(BuildContext context, Map<String, dynamic> difficultyStyle, bool isTablet) {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      alignment: WrapAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Time badge
            _buildTimeBadge(context, isTablet, true),
            const SizedBox(width: 6),
            
            // Difficulty badge
            _buildDifficultyBadge(context, difficultyStyle, isTablet, true),
            
            // Rating badge (only if available)
            if (widget.recipe.rating != null) ...[
              const SizedBox(width: 6),
              _buildRatingBadge(context, isTablet, true),
            ],
          ],
        ),
        
        // Favorite Icon
        _buildFavoriteIcon(context, isTablet, true),
      ],
    );
  }

  Widget _buildTimeBadge(BuildContext context, bool isTablet, bool isLandscape) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLandscape ? 6 : 8,
        vertical: isLandscape ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time_rounded,
            size: isLandscape ? 12 : (isTablet ? 16 : 14),
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            widget.recipe.cookTimeMinutes == null
                ? '30 min'
                : '${widget.recipe.cookTimeMinutes} min',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: isLandscape ? 10 : (isTablet ? 12 : 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyBadge(BuildContext context, Map<String, dynamic> difficultyStyle, bool isTablet, bool isLandscape) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLandscape ? 6 : 8,
        vertical: isLandscape ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: (difficultyStyle['color'] as Color).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: (difficultyStyle['color'] as Color).withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            difficultyStyle['icon'] as IconData,
            size: isLandscape ? 10 : (isTablet ? 14 : 12),
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            difficultyStyle['label'] as String,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: isLandscape ? 10 : (isTablet ? 12 : 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBadge(BuildContext context, bool isTablet, bool isLandscape) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLandscape ? 6 : 8,
        vertical: isLandscape ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            size: isLandscape ? 10 : (isTablet ? 14 : 12),
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            widget.recipe.rating!.toStringAsFixed(1),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: isLandscape ? 10 : (isTablet ? 12 : 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteIcon(BuildContext context, bool isTablet, bool isLandscape) {
    return Container(
      padding: EdgeInsets.all(isLandscape ? 4 : 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Icon(
        Icons.favorite_rounded,
        size: isLandscape ? 14 : (isTablet ? 20 : 18),
        color: Colors.white,
      ),
    );
  }
}