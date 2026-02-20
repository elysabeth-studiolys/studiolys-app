import 'package:flutter/material.dart';
import '../constants/app_gradients.dart';

/// Conteneur avec dégradé personnalisable
class GradientContainer extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;

  const GradientContainer({
    super.key,
    required this.child,
    this.gradient,
    this.borderRadius,
    this.padding,
    this.width,
    this.height,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      alignment: alignment,
      decoration: BoxDecoration(
        gradient: gradient ?? AppGradients.primaryGradient,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}
