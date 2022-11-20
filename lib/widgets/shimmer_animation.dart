// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCardAnimation extends StatelessWidget {
  bool isBlack;
  ShimmerCardAnimation({
    Key? key,
    this.isBlack = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200.0,
      height: 100.0,
      child: Shimmer.fromColors(
        baseColor: isBlack ? Colors.grey[600]! : Colors.grey[300]!,
        highlightColor: isBlack ? Colors.grey[700]! : Colors.grey[100]!,
        child: const Card(
          elevation: 1.0,
          child: SizedBox(height: 80),
        ),
      ),
    );
  }
}
