import 'package:flutter/material.dart';

class CircleContainer extends StatelessWidget {
  final double w;
  final double h;
  final Color color;

  const CircleContainer({
    super.key,
    required this.w,
    required this.h,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: w,
      height: h,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
