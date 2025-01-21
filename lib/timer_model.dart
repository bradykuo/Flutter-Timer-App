// lib/timer_model.dart
import 'dart:async';
import 'package:flutter/foundation.dart';

enum TimerMode { countdown, stopwatch }

class TimerModel extends ChangeNotifier {
  int _duration = 0;
  int _remainingTime = 0;
  bool _isRunning = false;
  Timer? _timer;
  String name = '計時器';
  TimerMode _mode = TimerMode.countdown;

  int get duration => _duration;
  int get remainingTime => _remainingTime;
  bool get isRunning => _isRunning;
  TimerMode get mode => _mode;
  
  // 切換計時模式
  void toggleMode() {
    _mode = _mode == TimerMode.countdown ? TimerMode.stopwatch : TimerMode.countdown;
    reset();
    notifyListeners();
  }

  void setDuration(int minutes) {
    _duration = minutes * 60;
    _remainingTime = _mode == TimerMode.countdown ? _duration : 0;
    notifyListeners();
  }

  // 設定自訂時間（小時、分鐘、秒）
  void setCustomDuration(int hours, int minutes, int seconds) {
    _duration = (hours * 3600) + (minutes * 60) + seconds;
    _remainingTime = _mode == TimerMode.countdown ? _duration : 0;
    notifyListeners();
  }

  void start() {
    if (!_isRunning) {
      if (_mode == TimerMode.countdown && _remainingTime <= 0) return;
      
      _isRunning = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_mode == TimerMode.countdown) {
          if (_remainingTime > 0) {
            _remainingTime--;
            notifyListeners();
          } else {
            stop();
          }
        } else {
          // 正計時模式
          _remainingTime++;
          notifyListeners();
        }
      });
      notifyListeners();
    }
  }

  void stop() {
    _isRunning = false;
    _timer?.cancel();
    notifyListeners();
  }

  void pause() {
    _isRunning = false;
    _timer?.cancel();
    notifyListeners();
  }

  void reset() {
    _isRunning = false;
    _timer?.cancel();
    _remainingTime = _mode == TimerMode.countdown ? _duration : 0;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}