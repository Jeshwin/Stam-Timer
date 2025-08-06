import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:lucide_icons/lucide_icons.dart';

void main() {
  runApp(const StamFocusApp());
}

class StamFocusApp extends StatelessWidget {
  const StamFocusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stam Focus',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/wood-veneer-2354-in-architextures.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFE3E8E6), Color(0xFFABBAB2)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 32,
                        offset: const Offset(16, 16),
                      ),
                      BoxShadow(
                        inset: true,
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 16,
                        offset: const Offset(-8, -8),
                      ),
                      BoxShadow(
                        inset: true,
                        color: Colors.white.withValues(alpha: 0.25),
                        blurRadius: 16,
                        offset: const Offset(8, 8),
                      ),
                      BoxShadow(
                        inset: true,
                        color: Color(0xFF888888).withValues(alpha: 0.25),
                        blurRadius: 16,
                        offset: const Offset(-4, 4),
                      ),
                      BoxShadow(
                        inset: true,
                        color: Color(0xFF888888).withValues(alpha: 0.25),
                        blurRadius: 16,
                        offset: const Offset(4, -4),
                      ),
                    ],
                  ),
                  child: const TimerInterface(),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                  icon: Icon(
                    LucideIcons.settings,
                    color: Colors.black.withValues(alpha: 0.5),
                    size: 40,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/wood-veneer-2354-in-architextures.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back, size: 30),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'Settings will be added here',
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TimerInterface extends StatelessWidget {
  const TimerInterface({super.key});

  final sevenSegmentStyle = const TextStyle(
    fontSize: 64,
    height: 1,
    color: Colors.black,
    fontFamily: "7 Segment",
  );

  @override
  Widget build(BuildContext context) {
    const int activeLights = 2; // Variable for how many lights to show as on
    const int totalLights = 6;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Timer Display
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF798F70),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                inset: true,
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 2,
                offset: const Offset(2, 2),
              ),
              BoxShadow(
                inset: true,
                color: Colors.white.withValues(alpha: 0.1),
                blurRadius: 2,
                offset: const Offset(-2, -2),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background "off" segments (88:88)
              Text(
                '88:88',
                style: sevenSegmentStyle.copyWith(
                  color: Colors.black.withValues(alpha: 0.1),
                ),
              ),
              // Foreground active segments (15:00)
              Text('15:00', style: sevenSegmentStyle),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Indicator Lights
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(totalLights, (index) {
            return Container(
              width: 12,
              height: 12,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index < activeLights
                    ? const Color(0xFF00FF00) // Bright green for active
                    : const Color(0xFFDDDDDD), // Light gray for inactive
                boxShadow: index < activeLights
                    ? [
                        BoxShadow(
                          color: const Color(0xFF00FF00).withValues(alpha: 0.5),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
            );
          }),
        ),

        const SizedBox(height: 24),

        // Control Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left button (placeholder)
            _buildControlButton(LucideIcons.rotateCcw, () {}),
            SizedBox(width: 16),
            // Center button (placeholder) - larger
            _buildControlButton(
              LucideIcons.play,
              () {},
              size: 60,
              iconSize: 30,
            ),
            SizedBox(width: 16),
            // Right button (skip)
            _buildControlButton(LucideIcons.skipForward, () {}),
          ],
        ),
      ],
    );
  }

  Widget _buildControlButton(
    IconData icon,
    VoidCallback onPressed, {
    double size = 45,
    double iconSize = 22,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE3E8E6), Color(0xFFABBAB2)],
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
          color: Colors.black.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}
