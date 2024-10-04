import 'package:flutter/material.dart';

class OverlayGradientWidget extends StatelessWidget {
  const OverlayGradientWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final gradientColor = Theme.of(context).colorScheme.primary;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            gradientColor,
            gradientColor.withOpacity(0.8),
            gradientColor.withOpacity(0.4),
          ],
        ),
      ),
    );
  }
}
