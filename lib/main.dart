// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'timer_screen.dart';

void main() {
  runApp(const TimerApp());
}

class TimerApp extends StatelessWidget {
  const TimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '多組計時器',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        cardTheme: CardTheme(
          elevation: Platform.isIOS ? 0 : 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Platform.isIOS ? 12 : 8),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
          ),
        ),
      ),
      home: const TimerScreen(),
    );
  }
}