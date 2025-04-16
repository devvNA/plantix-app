import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerSkeleton extends StatelessWidget {
  final double width;
  final double height;
  final bool isCircle;
  final double borderRadius;
  final bool isShimmering;

  const ShimmerSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.isCircle = false,
    this.borderRadius = 8.0,
    this.isShimmering = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isShimmering) {
      return _buildPlaceholder();
    }

    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle ? null : BorderRadius.circular(borderRadius),
      ),
    );
  }
}
