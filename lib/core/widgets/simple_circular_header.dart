import 'package:flutter/material.dart';
import '../constants/app_gradients.dart';
import '../constants/app_dimensions.dart';

class SimpleCircularHeader extends StatelessWidget {
  final Widget child;
  final double height;

  const SimpleCircularHeader({
    super.key,
    required this.child,
    this.height = 110,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Cercle avec gradient et ombre
        Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.elliptical(screenWidth * 3, 200),
              bottomRight: Radius.elliptical(screenWidth * 3, 200),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF000000).withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 5),
              ),
            ],
          ),
        ),
        
        // Contenu
        Positioned.fill(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingL,
                vertical: AppDimensions.paddingM,
              ),
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}