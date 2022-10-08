import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCardAnimation extends StatelessWidget {
  const ShimmerCardAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200.0,
      height: 100.0,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: const Card(
          elevation: 1.0,
          child: SizedBox(height: 80),
        ),
      ),
    );
  }
}
