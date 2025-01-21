// lib/timer_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'timer_model.dart';

class TimerWidget extends StatelessWidget {
  final TimerModel timer;
  final VoidCallback onDelete;

  const TimerWidget({
    super.key,
    required this.timer,
    required this.onDelete,
  });

  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _showCustomDurationDialog(BuildContext context) {
    final hoursController = TextEditingController();
    final minutesController = TextEditingController();
    final secondsController = TextEditingController();

    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('設定時間'),
            content: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CupertinoTextField(
                    controller: hoursController,
                    keyboardType: TextInputType.number,
                    placeholder: '小時',
                    decoration: BoxDecoration(
                      border: Border.all(color: CupertinoColors.systemGrey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  CupertinoTextField(
                    controller: minutesController,
                    keyboardType: TextInputType.number,
                    placeholder: '分鐘',
                    decoration: BoxDecoration(
                      border: Border.all(color: CupertinoColors.systemGrey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  CupertinoTextField(
                    controller: secondsController,
                    keyboardType: TextInputType.number,
                    placeholder: '秒',
                    decoration: BoxDecoration(
                      border: Border.all(color: CupertinoColors.systemGrey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () => Navigator.pop(context),
                child: const Text('取消'),
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  final hours = int.tryParse(hoursController.text) ?? 0;
                  final minutes = int.tryParse(minutesController.text) ?? 0;
                  final seconds = int.tryParse(secondsController.text) ?? 0;
                  timer.setCustomDuration(hours, minutes, seconds);
                  Navigator.pop(context);
                },
                child: const Text('確定'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('設定時間'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: hoursController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(
                          labelText: '小時',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: minutesController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(
                          labelText: '分鐘',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: secondsController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(
                          labelText: '秒',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () {
                  final hours = int.tryParse(hoursController.text) ?? 0;
                  final minutes = int.tryParse(minutesController.text) ?? 0;
                  final seconds = int.tryParse(secondsController.text) ?? 0;
                  timer.setCustomDuration(hours, minutes, seconds);
                  Navigator.pop(context);
                },
                child: const Text('確定'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIOS = Platform.isIOS;
    
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isIOS ? 12 : 8),
      ),
      child: ListenableBuilder(
        listenable: timer,
        builder: (context, child) {
          return Padding(
            padding: EdgeInsets.all(isIOS ? 20 : 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: isIOS 
                        ? CupertinoTextField(
                            placeholder: '計時器名稱',
                            onChanged: (value) => timer.name = value,
                            decoration: BoxDecoration(
                              border: Border.all(color: CupertinoColors.systemGrey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          )
                        : TextField(
                            decoration: const InputDecoration(
                              labelText: '計時器名稱',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) => timer.name = value,
                          ),
                    ),
                    IconButton(
                      icon: Icon(
                        timer.mode == TimerMode.countdown 
                          ? Icons.timer 
                          : Icons.timer_outlined,
                        color: isIOS ? CupertinoColors.activeBlue : null,
                      ),
                      onPressed: timer.toggleMode,
                      tooltip: timer.mode == TimerMode.countdown 
                          ? '切換到正計時' 
                          : '切換到倒數計時',
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: isIOS ? CupertinoColors.destructiveRed : null,
                      ),
                      onPressed: onDelete,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  _formatTime(timer.remainingTime),
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    fontFamily: isIOS ? '.SF UI Display' : null,
                  ),
                ),
                const SizedBox(height: 20),
                if (!timer.isRunning && 
                    timer.mode == TimerMode.countdown && 
                    timer.remainingTime == timer.duration)
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildTimeButton(context, '1分鐘', () => timer.setDuration(1)),
                          _buildTimeButton(context, '5分鐘', () => timer.setDuration(5)),
                          _buildTimeButton(context, '10分鐘', () => timer.setDuration(10)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildTimeButton(context, '自訂時間', () => _showCustomDurationDialog(context)),
                    ],
                  ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      context,
                      timer.isRunning ? Icons.pause : Icons.play_arrow,
                      timer.isRunning ? '暫停' : '開始',
                      timer.isRunning ? timer.pause : timer.start,
                      isPrimary: true,
                    ),
                    _buildActionButton(
                      context,
                      Icons.refresh,
                      '重設',
                      timer.reset,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeButton(BuildContext context, String text, VoidCallback onPressed) {
    if (Platform.isIOS) {
      return CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: CupertinoColors.systemBlue,
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
        onPressed: onPressed,
      );
    } else {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
        ),
        child: Text(text),
      );
    }
  }

  Widget _buildActionButton(
    BuildContext context, 
    IconData icon, 
    String label, 
    VoidCallback onPressed, 
    {bool isPrimary = false}
  ) {
    if (Platform.isIOS) {
      return CupertinoButton.filled(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: CupertinoColors.white),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
        onPressed: onPressed,
      );
    } else {
      return ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(label),
        onPressed: onPressed,
        style: isPrimary ? ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
        ) : null,
      );
    }
  }
}