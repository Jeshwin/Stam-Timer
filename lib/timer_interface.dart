import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:async';
import 'settings.dart';
import 'control_button.dart';

enum TimerType { work, shortBreak, longBreak }

class TimerInterface extends StatefulWidget {
  const TimerInterface({super.key});

  @override
  State<TimerInterface> createState() => _TimerInterfaceState();
}

class _TimerInterfaceState extends State<TimerInterface> {
  Timer? _timer;
  int _timeRemaining = 1500; // Initialize with 25 minutes in seconds
  bool _isRunning = false;
  int _currentCycleIndex = 0;
  int _totalCycles = 4;
  List<TimerType> _timerSequence = [];
  
  int _workDuration = 25;
  int _shortBreakDuration = 5;
  int _longBreakDuration = 15;

  @override
  void initState() {
    super.initState();
    _generateInitialTimerSequence();
    _loadSettingsAndInitialize();
  }

  void _generateInitialTimerSequence() {
    _timerSequence = [];
    for (int i = 0; i < _totalCycles; i++) {
      _timerSequence.add(TimerType.work);
      if (i == _totalCycles - 1) {
        _timerSequence.add(TimerType.longBreak);
      } else {
        _timerSequence.add(TimerType.shortBreak);
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadSettingsAndInitialize() async {
    final workDuration = await SettingsService.getWorkDuration();
    final shortBreakDuration = await SettingsService.getShortBreakDuration();
    final longBreakDuration = await SettingsService.getLongBreakDuration();
    final cycles = await SettingsService.getCycles();

    // Cancel any running timer
    _timer?.cancel();

    setState(() {
      _workDuration = workDuration;
      _shortBreakDuration = shortBreakDuration;
      _longBreakDuration = longBreakDuration;
      _totalCycles = cycles;
      _currentCycleIndex = 0; // Reset to beginning
      _generateTimerSequence();
      // Explicitly set time to work duration since we're at index 0
      _timeRemaining = workDuration * 60;
      _isRunning = false;
    });
  }

  void _generateTimerSequence() {
    _timerSequence = [];
    for (int i = 0; i < _totalCycles; i++) {
      _timerSequence.add(TimerType.work);
      if (i == _totalCycles - 1) {
        _timerSequence.add(TimerType.longBreak);
      } else {
        _timerSequence.add(TimerType.shortBreak);
      }
    }
  }

  TimerType get _currentTimerType => _timerSequence.isNotEmpty ? _timerSequence[_currentCycleIndex] : TimerType.work;

  int get _currentTimerDuration {
    switch (_currentTimerType) {
      case TimerType.work:
        return _workDuration;
      case TimerType.shortBreak:
        return _shortBreakDuration;
      case TimerType.longBreak:
        return _longBreakDuration;
    }
  }
  set _currentTimerDuration(int value) => _currentTimerDuration = value;

  void _startTimer() {
    if (_timeRemaining <= 0) return;
    
    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeRemaining--;
      });

      if (_timeRemaining <= 0) {
        _timer?.cancel();
        setState(() {
          _isRunning = false;
        });
        // Auto-transition to next timer
        _autoTransition();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }


  void _skipTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      if (_currentCycleIndex < _timerSequence.length - 1) {
        _currentCycleIndex++;
        _timeRemaining = _currentTimerDuration * 60;
      }
    });
  }

  void _resetToBeginning() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _currentCycleIndex = 0;
    });
    // Reload settings and reset timer
    _loadSettingsAndInitialize();
  }

  void _autoTransition() {
    if (_currentCycleIndex < _timerSequence.length - 1) {
      setState(() {
        _currentCycleIndex++;
        _timeRemaining = _currentTimerDuration * 60;
      });
    } else {
      // Cycle complete - reset to beginning
      setState(() {
        _currentCycleIndex = 0;
        _timeRemaining = _currentTimerDuration * 60;
      });
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Color _getLedColor(int index) {
    // All LEDs are green now
    return const Color(0xFF00FF00); // Green
  }

  bool _isLedActive(int index) {
    return index < _currentCycleIndex;
  }

  bool _isLedCurrent(int index) {
    return index == _currentCycleIndex;
  }

  bool _isLedCurrentAndPaused(int index) {
    return index == _currentCycleIndex && !_isRunning;
  }

  final sevenSegmentStyle = const TextStyle(
    fontSize: 64,
    height: 1,
    color: Colors.black,
    fontFamily: "7 Segment",
  );

  @override
  Widget build(BuildContext context) {
    final totalLights = _timerSequence.isNotEmpty ? _timerSequence.length : 8;

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
              // Foreground active segments
              Text(_formatTime(_timeRemaining), style: sevenSegmentStyle),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Indicator Lights
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(totalLights, (index) {
            final isCompleted = _isLedActive(index);
            final isCurrent = _isLedCurrent(index);
            final isCurrentAndPaused = _isLedCurrentAndPaused(index);
            final ledColor = _getLedColor(index);
            
            Color displayColor;
            List<BoxShadow>? boxShadows;
            
            if (isCompleted) {
              // Completed timers: full brightness
              displayColor = ledColor;
              boxShadows = [
                BoxShadow(
                  color: ledColor.withValues(alpha: 0.5),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ];
            } else if (isCurrent && _isRunning) {
              // Current timer running: full brightness
              displayColor = ledColor;
              boxShadows = [
                BoxShadow(
                  color: ledColor.withValues(alpha: 0.5),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ];
            } else if (isCurrentAndPaused) {
              // Current timer paused: dimmed with reduced glow
              displayColor = ledColor.withValues(alpha: 0.4);
              boxShadows = [
                BoxShadow(
                  color: ledColor.withValues(alpha: 0.2),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ];
            } else {
              // Inactive/future timers: gray
              displayColor = const Color(0xFFDDDDDD);
              boxShadows = null;
            }
            
            return Container(
              width: 12,
              height: 12,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: displayColor,
                boxShadow: boxShadows,
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
            // Reset button
            buildControlButton(LucideIcons.rotateCcw, _resetToBeginning),
            const SizedBox(width: 16),
            // Play/Pause button - larger
            buildControlButton(
              _isRunning ? LucideIcons.pause : LucideIcons.play,
              _isRunning ? _pauseTimer : _startTimer,
              size: 60,
              iconSize: 30,
            ),
            const SizedBox(width: 16),
            // Skip button
            buildControlButton(LucideIcons.skipForward, _skipTimer),
          ],
        ),
      ],
    );
  }
}