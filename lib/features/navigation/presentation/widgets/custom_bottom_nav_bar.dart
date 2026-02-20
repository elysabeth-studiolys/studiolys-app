import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_shadows.dart';
import '../providers/navigation_provider.dart';

class CustomBottomNavBar extends ConsumerWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);

    return Container(
      height: AppDimensions.bottomNavHeight,
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: AppShadows.bottomNavShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.home,
            isSelected: currentIndex == 0,
            onTap: () => ref.read(navigationIndexProvider.notifier).state = 0,
          ),
          _NavItem(
            icon: Icons.bar_chart,
            isSelected: currentIndex == 1,
            onTap: () => ref.read(navigationIndexProvider.notifier).state = 1,
          ),
          _CenterNavItem(
            onTap: () => ref.read(navigationIndexProvider.notifier).state = 2,
          ),
          _NavItem(
            icon: Icons.check_box_outlined,
            isSelected: currentIndex == 3,
            onTap: () => ref.read(navigationIndexProvider.notifier).state = 3,
          ),
          _NavItem(
            icon: Icons.book_outlined,
            isSelected: currentIndex == 4,
            onTap: () => ref.read(navigationIndexProvider.notifier).state = 4,
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Icon(
          icon,
          size: AppDimensions.bottomNavIconSize,
          color: isSelected
              ? AppColors.bottomNavSelected
              : AppColors.bottomNavUnselected,
        ),
      ),
    );
  }
}

class _CenterNavItem extends StatelessWidget {
  final VoidCallback onTap;

  const _CenterNavItem({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          boxShadow: AppShadows.buttonShadow,
        ),
        child: const Icon(
          Icons.add,
          size: AppDimensions.bottomNavCenterIconSize,
          color: Colors.white,
        ),
      ),
    );
  }
}
