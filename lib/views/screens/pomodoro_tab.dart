import 'dart:async';
import 'dart:math';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_and_task_management/utils/colors.dart';
import 'package:time_and_task_management/views/widgets/app_bar.dart';
import 'package:time_and_task_management/views/widgets/drawer.dart';
import 'package:time_and_task_management/views/widgets/time_picker_modal.dart';

class PomodoroTab extends StatefulWidget {
  const PomodoroTab({super.key});

  @override
  State<PomodoroTab> createState() => _PomodoroTabState();
}

enum TimerMode { focusMode, breakMode }

class _PomodoroTabState extends State<PomodoroTab>
    with SingleTickerProviderStateMixin {
  static const String _focusKey = 'focus_duration';
  static const String _breakKey = 'break_duration';
  final List<String> _quotes = [
    "Stay focused, you're doing great!",
    "One step at a time, keep going!",
    "Small progress is still progress",
    "You're closer than yesterday",
    "Keep your focus, stay strong"
  ];
  late Timer _quoteTimer;
  int _currentQuoteIndex = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  TimerMode _mode = TimerMode.focusMode;
  int _focusDuration = 25;
  int _breakDuration = 5;
  final CountDownController _controller = CountDownController();

  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);
    _loadSavedDurations();
  }

  void _startQuoteTimer() {
    _currentQuoteIndex = 0;
    _fadeController.forward();

    _quoteTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        _fadeController.reverse().then((_) {
          _currentQuoteIndex = (_currentQuoteIndex + 1) % _quotes.length;
          _fadeController.forward();
        });
      });
    });
  }

  Future<void> _loadSavedDurations() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _focusDuration = prefs.getInt(_focusKey) ?? 25;
      _breakDuration = prefs.getInt(_breakKey) ?? 5;
    });
  }

  Future<void> _saveDurations() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_focusKey, _focusDuration);
    await prefs.setInt(_breakKey, _breakDuration);
  }

  void _toggleMode() {
    setState(() {
      _mode = _mode == TimerMode.focusMode
          ? TimerMode.breakMode
          : TimerMode.focusMode;
      _controller.reset();
    });
  }

  void _showDurationPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => TimePickerModal(
        initialDuration:
            _mode == TimerMode.focusMode ? _focusDuration : _breakDuration,
        onDurationChanged: (newDuration) {
          setState(() {
            if (_mode == TimerMode.focusMode) {
              _focusDuration = newDuration;
            } else {
              _breakDuration = newDuration;
            }
            _saveDurations();
          });
        },
        isBreakMode: _mode == TimerMode.breakMode,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          _mode == TimerMode.breakMode
              ? 'Great work! Take a break!'
              : 'Break time is over!',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          _mode == TimerMode.breakMode
              ? 'You\'ve completed your focus session.'
              : 'Time to focus again!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          SAppBar(title: 'Pomodoro', isBreakMode: _mode == TimerMode.breakMode),
      body: Stack(
        children: [
          Center(
            child: Column(
              children: [
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: _toggleMode,
                  label: Text(
                    _mode == TimerMode.focusMode ? 'Focus Mode' : 'Break Mode',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _mode == TimerMode.focusMode
                        ? SColors.accent
                        : Colors.green.shade500,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 20),
                    Text(
                      'Set: ${_mode == TimerMode.focusMode ? _focusDuration : _breakDuration} minutes',
                      style: const TextStyle(fontSize: 16),
                    ),
                    IconButton(
                        onPressed: _showDurationPicker,
                        icon: const Icon(Icons.edit)),
                  ],
                ),
                CircularCountDownTimer(
                  duration: (_mode == TimerMode.focusMode
                          ? _focusDuration
                          : _breakDuration) *
                      60,
                  initialDuration: 0,
                  controller: _controller,
                  width: MediaQuery.of(context).size.width / 2,
                  height: 300,
                  ringColor: Colors.grey.shade300,
                  fillColor: _mode == TimerMode.focusMode
                      ? SColors.accent
                      : Colors.green.shade500,
                  backgroundColor: _mode == TimerMode.focusMode
                      ? SColors.secondary
                      : Colors.lightGreen.shade200,
                  strokeWidth: 5.0,
                  strokeCap: StrokeCap.round,
                  textStyle: TextStyle(
                    fontSize: 33.0,
                    color: _mode == TimerMode.focusMode
                        ? Colors.white
                        : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                  textFormat: CountdownTextFormat.MM_SS,
                  isReverse: true,
                  isReverseAnimation: false,
                  isTimerTextShown: true,
                  autoStart: false,
                  onStart: () {
                    debugPrint('Countdown Started');
                    if (_mode == TimerMode.focusMode) {
                      _startQuoteTimer();
                    }
                  },
                  onComplete: () {
                    debugPrint('Countdown Ended');
                    _confettiController.play();
                    HapticFeedback.mediumImpact();
                    _showCompletionDialog();
                    _toggleMode();
                    _quoteTimer.cancel();
                  },
                  onChange: (String timeStamp) {
                    debugPrint('Countdown Changed $timeStamp');
                  },
                ),
                const SizedBox(height: 20),
                (_mode == TimerMode.focusMode)
                    ? FadeTransition(
                        opacity: _fadeAnimation,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            _quotes[_currentQuoteIndex],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.1,
            ),
          ),
        ],
      ),
      drawer: const SDrawer(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          backgroundColor: _mode == TimerMode.focusMode
              ? SColors.primaryFirst
              : Colors.lightGreen.shade400,
          foregroundColor: SColors.textPrimary,
          spacing: 12,
          spaceBetweenChildren: 12,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.play_arrow),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              label: 'Start',
              onTap: () {
                _controller.restart(
                    duration: _mode == TimerMode.focusMode
                        ? _focusDuration * 60
                        : _breakDuration * 60);
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.pause),
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              label: 'Pause',
              onTap: () => _controller.pause(),
            ),
            SpeedDialChild(
              child: const Icon(Icons.refresh),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              label: 'Resume',
              onTap: () => _controller.resume(),
            ),
            SpeedDialChild(
              child: const Icon(Icons.stop),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              label: 'Stop',
              onTap: () => _controller.reset(),
            ),
          ],
          overlayOpacity: 0.3,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _quoteTimer.cancel();
    _fadeController.dispose();
    _confettiController.dispose();
    super.dispose();
  }
}
