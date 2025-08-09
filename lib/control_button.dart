import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'color_palettes.dart';

Widget buildControlButton(
  IconData icon,
  VoidCallback onPressed,
  TimerGradientPalette timerPalette, {
  double size = 45,
  double iconSize = 22,
}) {

  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [timerPalette.startColor, timerPalette.endColor],
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: 4,
          offset: const Offset(2, 2),
        ),
        BoxShadow(
          inset: true,
          color: Colors.white.withValues(alpha: 0.2),
          blurRadius: 2,
          offset: const Offset(-1, -1),
        ),
        BoxShadow(
          inset: true,
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 2,
          offset: const Offset(1, 1),
        ),
      ],
    ),
    child: IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: iconSize,
        color: timerPalette.iconColor.withValues(alpha: 0.7),
      ),
    ),
  );
}