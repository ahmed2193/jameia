import 'package:flutter/material.dart';
import 'package:jameia/features/recipes/presentation/widgets/shimmer_widget.dart';

class RecipeListItemShimmer extends StatelessWidget {
  const RecipeListItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final cardHeight = isTablet ? 280.0 : 220.0;
    
    return Container(
      height: cardHeight,
      margin: EdgeInsets.symmetric(
        horizontal: isTablet ? 12.0 : 8.0,
        vertical: 8.0,
      ),
      child: Card(
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ShimmerWidget(
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image Shimmer
              const ShimmerPlaceholder(
                height: double.infinity,
                width: double.infinity,
              ),
              
              // Gradient Overlay (same as original)
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
              
              // Content Shimmer
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
                      // Recipe Name Shimmer
                      ShimmerPlaceholder(
                        height: isTablet ? 28 : 24,
                        width: screenWidth * 0.7,
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Second line of title (shorter)
                      ShimmerPlaceholder(
                        height: isTablet ? 28 : 24,
                        width: screenWidth * 0.5,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Metadata Row Shimmer
                      Row(
                        children: [
                          // Time Badge Shimmer
                          ShimmerPlaceholder(
                            height: isTablet ? 32 : 28,
                            width: isTablet ? 80 : 70,
                          ),
                          
                          const SizedBox(width: 8),
                          
                          // Difficulty Badge Shimmer
                          ShimmerPlaceholder(
                            height: isTablet ? 32 : 28,
                            width: isTablet ? 60 : 50,
                          ),
                          
                          const Spacer(),
                          
                          // Favorite Icon Shimmer
                          ShimmerPlaceholder(
                            height: isTablet ? 44 : 40,
                            width: isTablet ? 44 : 40,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}