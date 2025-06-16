import 'package:flutter/material.dart';
import 'package:jameia/features/recipes/presentation/widgets/shimmer_widget.dart';

class RecipeDetailsShimmer extends StatelessWidget {
  const RecipeDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWidget(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Chips
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                4,
                (index) => const ShimmerPlaceholder(width: 80, height: 70),
              ),
            ),
            const SizedBox(height: 24),
            // Ingredients Title
            const ShimmerPlaceholder(width: 200, height: 28),
            const SizedBox(height: 16),
            // Ingredient List
            ...List.generate(
              5,
              (index) => const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: ShimmerPlaceholder(height: 20),
              ),
            ),
            const SizedBox(height: 24),
            // Instructions Title
            const ShimmerPlaceholder(width: 220, height: 28),
            const SizedBox(height: 16),
            // Instruction List
            ...List.generate(
              4,
              (index) => const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: ShimmerPlaceholder(height: 40),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
