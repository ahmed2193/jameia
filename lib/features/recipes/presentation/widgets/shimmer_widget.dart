import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final Widget child;

  const ShimmerWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDarkMode ? Colors.grey[850]! : Colors.grey[300]!,
      highlightColor: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
      child: child,
    );
  }
}

class ShimmerPlaceholder extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxShape shape;
  final EdgeInsetsGeometry margin;

  const ShimmerPlaceholder({
    super.key,
    this.width,
    this.height,
    this.shape = BoxShape.rectangle,
    this.margin = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: shape,
        borderRadius:
            shape == BoxShape.rectangle ? BorderRadius.circular(8) : null,
      ),
    );
  }
}