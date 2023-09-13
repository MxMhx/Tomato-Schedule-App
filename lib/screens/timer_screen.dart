import 'dart:async';

import 'package:flutter/material.dart';

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
                return Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.blue,
                      width: 10,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      value.toString(),
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
