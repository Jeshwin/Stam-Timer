import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'color_palettes.dart';

class SettingsService {
  static const String _workDurationKey = 'work_duration';
  static const String _shortBreakDurationKey = 'short_break_duration';
  static const String _longBreakDurationKey = 'long_break_duration';
  static const String _cyclesKey = 'cycles';
  static const String _timerColorKey = 'timer_color';
  static const String _ledColorKey = 'led_color';
  static const String _backgroundKey = 'background';

  static Future<int> getWorkDuration() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_workDurationKey) ?? 25;
  }

  static Future<int> getShortBreakDuration() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_shortBreakDurationKey) ?? 5;
  }

  static Future<int> getLongBreakDuration() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_longBreakDurationKey) ?? 15;
  }

  static Future<int> getCycles() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_cyclesKey) ?? 4;
  }

  static Future<void> setWorkDuration(int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_workDurationKey, minutes);
  }

  static Future<void> setShortBreakDuration(int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_shortBreakDurationKey, minutes);
  }

  static Future<void> setLongBreakDuration(int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_longBreakDurationKey, minutes);
  }

  static Future<void> setCycles(int cycles) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_cyclesKey, cycles);
  }

  static Future<int> getTimerColorIndex() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_timerColorKey) ?? 0;
  }

  static Future<int> getLedColorIndex() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_ledColorKey) ?? 0;
  }

  static Future<void> setTimerColorIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_timerColorKey, index);
  }

  static Future<void> setLedColorIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_ledColorKey, index);
  }

  static Future<int> getBackgroundIndex() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_backgroundKey) ?? 0;
  }

  static Future<void> setBackgroundIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_backgroundKey, index);
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _workDuration = 25;
  int _shortBreakDuration = 5;
  int _longBreakDuration = 15;
  int _cycles = 4;
  int _timerColorIndex = 0;
  int _ledColorIndex = 0;
  int _backgroundIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final workDuration = await SettingsService.getWorkDuration();
    final shortBreakDuration = await SettingsService.getShortBreakDuration();
    final longBreakDuration = await SettingsService.getLongBreakDuration();
    final cycles = await SettingsService.getCycles();
    final timerColorIndex = await SettingsService.getTimerColorIndex();
    final ledColorIndex = await SettingsService.getLedColorIndex();
    final backgroundIndex = await SettingsService.getBackgroundIndex();

    setState(() {
      _workDuration = workDuration;
      _shortBreakDuration = shortBreakDuration;
      _longBreakDuration = longBreakDuration;
      _cycles = cycles;
      _timerColorIndex = timerColorIndex;
      _ledColorIndex = ledColorIndex;
      _backgroundIndex = backgroundIndex;
    });
  }

  void _saveWorkDurationAsync(int value) {
    SettingsService.setWorkDuration(value);
  }

  void _saveShortBreakDurationAsync(int value) {
    SettingsService.setShortBreakDuration(value);
  }

  void _saveLongBreakDurationAsync(int value) {
    SettingsService.setLongBreakDuration(value);
  }

  void _saveCyclesAsync(int value) {
    SettingsService.setCycles(value);
  }

  void _saveTimerColorAsync(int value) {
    SettingsService.setTimerColorIndex(value);
  }

  void _saveLedColorAsync(int value) {
    SettingsService.setLedColorIndex(value);
  }

  void _saveBackgroundAsync(int value) {
    SettingsService.setBackgroundIndex(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              ColorPalettes.getBackground(_backgroundIndex).assetPath,
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
                      icon: const Icon(Icons.arrow_back, size: 30),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildSectionCard('Pomodoro Timer Settings', [
                      _buildSliderSetting(
                        'Work Duration',
                        '$_workDuration minutes',
                        _workDuration.toDouble(),
                        5,
                        60,
                        (value) {
                          setState(() {
                            _workDuration = value.round();
                          });
                          _saveWorkDurationAsync(value.round());
                        },
                        increment: 5,
                      ),
                      _buildSliderSetting(
                        'Short Break Duration',
                        '$_shortBreakDuration minutes',
                        _shortBreakDuration.toDouble(),
                        1,
                        30,
                        (value) {
                          setState(() {
                            _shortBreakDuration = value.round();
                          });
                          _saveShortBreakDurationAsync(value.round());
                        },
                      ),
                      _buildSliderSetting(
                        'Long Break Duration',
                        '$_longBreakDuration minutes',
                        _longBreakDuration.toDouble(),
                        5,
                        60,
                        (value) {
                          setState(() {
                            _longBreakDuration = value.round();
                          });
                          _saveLongBreakDurationAsync(value.round());
                        },
                        increment: 5,
                      ),
                      _buildSliderSetting(
                        'Number of Cycles',
                        '$_cycles cycles',
                        _cycles.toDouble(),
                        1,
                        8,
                        (value) {
                          setState(() {
                            _cycles = value.round();
                          });
                          _saveCyclesAsync(value.round());
                        },
                      ),
                    ]),
                    const SizedBox(height: 16),
                    _buildSectionCard('Customization', [
                      _buildDropdownSetting(
                        'Timer Color',
                        ColorPalettes.timerGradients[_timerColorIndex].name,
                        ColorPalettes.timerGradients.map((e) => e.name).toList(),
                        (String? value) {
                          if (value != null) {
                            final index = ColorPalettes.getTimerGradientIndex(value);
                            setState(() {
                              _timerColorIndex = index;
                            });
                            _saveTimerColorAsync(index);
                          }
                        },
                      ),
                      _buildDropdownSetting(
                        'LED Color',
                        ColorPalettes.ledColors[_ledColorIndex].name,
                        ColorPalettes.ledColors.map((e) => e.name).toList(),
                        (String? value) {
                          if (value != null) {
                            final index = ColorPalettes.getLedColorIndex(value);
                            setState(() {
                              _ledColorIndex = index;
                            });
                            _saveLedColorAsync(index);
                          }
                        },
                      ),
                      _buildDropdownSetting(
                        'Background Wood Type',
                        ColorPalettes.backgrounds[_backgroundIndex].name,
                        ColorPalettes.backgrounds.map((e) => e.name).toList(),
                        (String? value) {
                          if (value != null) {
                            final index = ColorPalettes.getBackgroundIndex(value);
                            setState(() {
                              _backgroundIndex = index;
                            });
                            _saveBackgroundAsync(index);
                          }
                        },
                      ),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSliderSetting(
    String title,
    String value,
    double currentValue,
    double min,
    double max,
    Function(double) onChanged, {
    int increment = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF798F70),
              inactiveTrackColor: Colors.grey[300],
              thumbColor: const Color(0xFF798F70),
              overlayColor: const Color(0xFF798F70).withValues(alpha: 0.2),
            ),
            child: Slider(
              value: currentValue,
              min: min,
              max: max,
              divisions: ((max - min) / increment).round(),
              onChanged: (double value) => onChanged(value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSetting(
    String title,
    String currentValue,
    List<String> options,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: currentValue,
                isExpanded: true,
                items: options.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderSetting(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          Text(
            '$value (Coming Soon)',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black38,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
