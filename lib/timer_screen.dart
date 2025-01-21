// lib/timer_screen.dart
import 'package:flutter/material.dart';
import 'timer_widget.dart';
import 'timer_model.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  final List<TimerModel> timers = [];

  void addTimer() {
    setState(() {
      timers.add(TimerModel());
    });
  }

  void removeTimer(int index) {
    setState(() {
      timers[index].dispose();
      timers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('多組計時器'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: addTimer,
          ),
        ],
      ),
      body: timers.isEmpty
          ? const Center(
              child: Text('點擊右上角 + 新增計時器',
                  style: TextStyle(fontSize: 18)),
            )
          : ListView.builder(
              itemCount: timers.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(timers[index].hashCode.toString()),
                  onDismissed: (direction) => removeTimer(index),
                  child: TimerWidget(
                    timer: timers[index],
                    onDelete: () => removeTimer(index),
                  ),
                );
              },
            ),
    );
  }

  @override
  void dispose() {
    for (var timer in timers) {
      timer.dispose();
    }
    super.dispose();
  }
}