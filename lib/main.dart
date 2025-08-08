import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'settings.dart';
import 'timer_interface.dart';

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

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late TimerInterface _timerInterface;

  @override
  void initState() {
    super.initState();
    _timerInterface = const TimerInterface();
  }

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
                  child: _timerInterface,
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: IconButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                    // Reload the timer interface by rebuilding the widget
                    setState(() {
                      _timerInterface = const TimerInterface();
                    });
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