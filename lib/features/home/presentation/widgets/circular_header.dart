import 'package:flutter/material.dart';
import '../../../../core/constants/app_gradients.dart';
import '../../../../core/constants/app_dimensions.dart';

class CircularHeader extends StatelessWidget {
  final Widget child;
  final bool showIllustration; 
  final String? illustrationPath;  

  const CircularHeader({
    super.key,
    required this.child,
    this.showIllustration = false,
    this.illustrationPath,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Stack(
      clipBehavior: Clip.none,
      children: [

        Container(
          height: showIllustration ? 400 : 230,  
          decoration: BoxDecoration(
            gradient: AppGradients.primaryGradient,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.elliptical(screenWidth * 2, 400),
              bottomRight: Radius.elliptical(screenWidth * 2, 400),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF63DBC4).withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 5),
              ),
            ],
          ),
        ),
        
        // Image illustration 
        if (showIllustration && illustrationPath != null)
          Positioned(
            bottom:-60,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                illustrationPath!,
                height: 380,  
                fit: BoxFit.contain,


               
              ),
            ),
          ),
        
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            child: child,
          ),
        ),
      ],
    );
  }
}