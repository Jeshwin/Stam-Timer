import 'package:flutter/material.dart';

class TimerGradientPalette {
  final String name;
  final Color startColor;
  final Color endColor;
  final Color displayBackgroundColor;
  final Color iconColor;

  const TimerGradientPalette({
    required this.name,
    required this.startColor,
    required this.endColor,
    required this.displayBackgroundColor,
    required this.iconColor,
  });
}

class LedColorPalette {
  final String name;
  final Color activeColor;

  const LedColorPalette({
    required this.name,
    required this.activeColor,
  });
}

class BackgroundPalette {
  final String name;
  final String assetPath;

  const BackgroundPalette({
    required this.name,
    required this.assetPath,
  });
}

class ColorPalettes {
  // Timer Gradient Palettes
  static const List<TimerGradientPalette> timerGradients = [
    TimerGradientPalette(
      name: 'Silver',
      startColor: Color(0xFFE3E8E6),
      endColor: Color(0xFFABBAB2),
      displayBackgroundColor: Color(0xFF798F70),
      iconColor: Color(0xFF000000),
    ),
    TimerGradientPalette(
      name: 'Blue',
      startColor: Color(0xFF66AACC),
      endColor: Color(0xFF3D668F),
      displayBackgroundColor: Color(0xFF798F70),
      iconColor: Color(0xFF000000),
    ),
    TimerGradientPalette(
      name: 'Yellow',
      startColor: Color(0xFFDDC23C),
      endColor: Color(0xFFA39B29),
      displayBackgroundColor: Color(0xFF798F70),
      iconColor: Color(0xFF000000),
    ),
    TimerGradientPalette(
      name: 'Green',
      startColor: Color(0xFF66CC88),
      endColor: Color(0xFF267326),
      displayBackgroundColor: Color(0xFF798F70),
      iconColor: Color(0xFF000000),
    ),
    TimerGradientPalette(
      name: 'Black',
      startColor: Color(0xFF061313),
      endColor: Color(0xFF061313),
      displayBackgroundColor: Color(0xFF798F70),
      iconColor: Color(0xFFFFFFFF), // White icons for dark theme
    ),
    TimerGradientPalette(
      name: 'Purple',
      startColor: Color(0xFF4D33CC),
      endColor: Color(0xFF3D3D8F),
      displayBackgroundColor: Color(0xFF798F70),
      iconColor: Color(0xFF000000),
    ),
    TimerGradientPalette(
      name: 'Orange',
      startColor: Color(0xFFF5B83D),
      endColor: Color(0xFFA36629),
      displayBackgroundColor: Color(0xFF798F70),
      iconColor: Color(0xFF000000),
    ),
    TimerGradientPalette(
      name: 'Red',
      startColor: Color(0xFFBF4040),
      endColor: Color(0xFF733326),
      displayBackgroundColor: Color(0xFF798F70),
      iconColor: Color(0xFF000000),
    ),
    TimerGradientPalette(
      name: 'Maroon',
      startColor: Color(0xFF330000),
      endColor: Color(0xFF660000),
      displayBackgroundColor: Color(0xFF798F70),
      iconColor: Color(0xFFFFFFFF), // White icons for dark theme
    ),
  ];

  // LED Color Palettes
  static const List<LedColorPalette> ledColors = [
    LedColorPalette(
      name: 'Green',
      activeColor: Color(0xFF00FF00),
    ),
    LedColorPalette(
      name: 'Blue',
      activeColor: Color(0xFF0080FF),
    ),
    LedColorPalette(
      name: 'Red',
      activeColor: Color(0xFFFF4500),
    ),
    LedColorPalette(
      name: 'Pink',
      activeColor: Color(0xFFFF1493),
    ),
    LedColorPalette(
      name: 'Cyan',
      activeColor: Color(0xFF00FFFF),
    ),
    LedColorPalette(
      name: 'Purple',
      activeColor: Color(0xFF8A2BE2),
    ),
    LedColorPalette(
      name: 'Orange',
      activeColor: Color(0xFFFFA500),
    ),
  ];

  // Background Wood Palettes
  static const List<BackgroundPalette> backgrounds = [
    BackgroundPalette(
      name: 'Wood Veneer',
      assetPath: 'assets/images/wood-veneer-2354-in-architextures.jpg',
    ),
    BackgroundPalette(
      name: 'Walnut',
      assetPath: 'assets/images/walnut-12598-in-architextures.jpg',
    ),
    BackgroundPalette(
      name: 'Oak',
      assetPath: 'assets/images/oak-12894-in-architextures.jpg',
    ),
    BackgroundPalette(
      name: 'Oak Cladding',
      assetPath: 'assets/images/oak-cladding-5118-in-architextures.jpg',
    ),
    BackgroundPalette(
      name: 'Oak Herringbone',
      assetPath: 'assets/images/oak-herringbone-18228-in-architextures.jpg',
    ),
    BackgroundPalette(
      name: 'Dark Wood Veneer',
      assetPath: 'assets/images/dark-wood-veneer-2362-in-architextures.jpg',
    ),
    BackgroundPalette(
      name: 'Charred Timber',
      assetPath: 'assets/images/charred-timber-13504-in-architextures.jpg',
    ),
    BackgroundPalette(
      name: 'Ash Chevron',
      assetPath: 'assets/images/ash-chevron-15748-in-architextures.jpg',
    ),
    BackgroundPalette(
      name: 'Ash',
      assetPath: 'assets/images/ash-12598-in-architextures.jpg',
    ),
  ];

  // Helper methods to get palettes by index
  static TimerGradientPalette getTimerGradient(int index) {
    return timerGradients[index.clamp(0, timerGradients.length - 1)];
  }

  static LedColorPalette getLedColor(int index) {
    return ledColors[index.clamp(0, ledColors.length - 1)];
  }

  static BackgroundPalette getBackground(int index) {
    return backgrounds[index.clamp(0, backgrounds.length - 1)];
  }

  // Helper methods to find index by name
  static int getTimerGradientIndex(String name) {
    for (int i = 0; i < timerGradients.length; i++) {
      if (timerGradients[i].name == name) return i;
    }
    return 0; // Default to first palette
  }

  static int getLedColorIndex(String name) {
    for (int i = 0; i < ledColors.length; i++) {
      if (ledColors[i].name == name) return i;
    }
    return 0; // Default to first palette
  }

  static int getBackgroundIndex(String name) {
    for (int i = 0; i < backgrounds.length; i++) {
      if (backgrounds[i].name == name) return i;
    }
    return 0; // Default to first palette
  }
}