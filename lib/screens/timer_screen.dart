import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  final int _secondsRemaining = 60;
  late ValueNotifier<int> _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = ValueNotifier<int>(_secondsRemaining);

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        if (_notifier.value > 0) {
          _notifier.value--;
        } else {
          timer.cancel();
        }
      }
    });
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder<int>(
              valueListenable: _notifier,
              builder: (context, value, child) {
                double percent = (value / _secondsRemaining);
                return CircularPercentIndicator(
                  radius: 150.0,
                  lineWidth: 20.0,
                  percent: percent,
                  center: Text(
                    value.toString(),
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: Colors.white,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
