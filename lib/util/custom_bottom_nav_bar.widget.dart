import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../constants/app_images.dart';
import '../constants/app_sizes.dart';
import '../constants/app_strings.dart';
import '../theme/app_theme.dart';

class CustomBottomNavBarWidget extends StatelessWidget {
  const CustomBottomNavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppThemeService.colorPalette.btmAppBarBackgroundColor.color,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppThemeService.colorPalette.btmAppBarBackgroundColor.color,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: AppSizes.s10,
              offset: const Offset(0, -2),
            ),
          ],
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(AppSizes.s26),
              topLeft: Radius.circular(AppSizes.s26)),
        ),
        child: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BottomNavItem(
                icon: AppImages.homeBottomBarIcon,
                label: AppStrings.home,
                isSelected: true,
                onTap: () {},
              ),
              BottomNavItem(
                  icon: AppImages.notificationBottomBarIcon,
                  label: AppStrings.notifications,
                  isSelected: false,
                  onTap: () {}),
              BottomNavItem(
                icon: AppImages.moreBottomBarIcon,
                label: AppStrings.more,
                isSelected: false,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const BottomNavItem({
    super.key,
    required this.icon,
    required this.label,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            icon,
            height: AppSizes.s20,
            width: AppSizes.s20,
            colorFilter: ColorFilter.mode(
              isSelected
                  ? Theme.of(context).colorScheme.secondary
                  : const Color(0xFF676D75),
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: AppSizes.s6),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: AppSizes.s10,
              letterSpacing: 1,
              color: isSelected
                  ? Theme.of(context).colorScheme.secondary
                  : const Color(0xFF676D75),
            ),
          ),
        ],
      ),
    );
  }
}
