import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'settings.dart';
import 'timer_interface.dart';
import 'background_timer_service.dart';
import 'color_palettes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BackgroundTimerService.initialize();
  runApp(const StamFocusApp());
}

class StamFocusApp extends StatelessWidget {
  const StamFocusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  TimerGradientPalette _timerPalette = ColorPalettes.timerGradients[0];
  BackgroundPalette _backgroundPalette = ColorPalettes.backgrounds[0];
  Key _timerKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final colorIndex = await SettingsService.getTimerColorIndex();
    final backgroundIndex = await SettingsService.getBackgroundIndex();
    setState(() {
      _timerPalette = ColorPalettes.getTimerGradient(colorIndex);
      _backgroundPalette = ColorPalettes.getBackground(backgroundIndex);
    });
  }

  Future<void> _refreshAll() async {
    await _loadSettings();
    setState(() {
      _timerKey = UniqueKey(); // This forces the TimerInterface to rebuild
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_backgroundPalette.assetPath),
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
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [_timerPalette.startColor, _timerPalette.endColor],
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
                  child: TimerInterface(key: _timerKey),
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
                    // Automatically refresh everything when returning from settings
                    await _refreshAll();
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