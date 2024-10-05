import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget(
      {super.key, this.color, required this.icon, required this.text});

  final IconData icon;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: AppSizes.s140,
              color: color ?? Colors.white,
            ),
            Text(
              text,
              style: TextStyle(
                  fontSize: AppSizes.s20, color: color ?? Colors.white),
            ),
          ],
        ),
      );
}
