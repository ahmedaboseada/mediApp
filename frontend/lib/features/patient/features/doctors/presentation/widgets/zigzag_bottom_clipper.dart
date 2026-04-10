import 'package:flutter/material.dart';

/// Sharp zigzag / torn-paper bottom clipper
class ZigzagBottomClipper extends CustomClipper<Path> {
  const ZigzagBottomClipper({
    this.minDepth = 18,
    this.maxDepth = 35,
    this.segmentWidth = 14,
    this.seed = 17,
  }) : assert(minDepth >= 0),
       assert(maxDepth >= minDepth),
       assert(segmentWidth > 0);

  final double minDepth;
  final double maxDepth;
  final double segmentWidth;
  final int seed;

  @override
  Path getClip(Size size) {
    final Path path = Path();

    final double baseY = size.height - ((minDepth + maxDepth) / 2);

    // Top rectangle
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, baseY);

    int i = 0;

    // Sharp zigzag bottom
    for (double x = size.width; x > 0; x -= segmentWidth, i++) {
      final double nextX = (x - segmentWidth).clamp(0, size.width);
      final double midX = (x + nextX) / 2;

      final double depth = _randomDepth(i);

      // 🔥 Sharp triangle (more aggressive)
      path.lineTo(midX, size.height);
      path.lineTo(nextX, size.height - depth);
    }

    path.lineTo(0, 0);
    path.close();

    return path;
  }

  double _randomDepth(int index) {
    if (maxDepth == minDepth) return minDepth;

    final double t = _unitNoise(index * 2 + 1);
    return minDepth + (maxDepth - minDepth) * t;
  }

  double _unitNoise(int n) {
    final int v = (n + seed) * 1103515245 + 12345;
    return ((v & 0x7fffffff) % 10000) / 10000.0;
  }

  @override
  bool shouldReclip(covariant ZigzagBottomClipper oldClipper) {
    return oldClipper.minDepth != minDepth ||
        oldClipper.maxDepth != maxDepth ||
        oldClipper.segmentWidth != segmentWidth ||
        oldClipper.seed != seed;
  }
}