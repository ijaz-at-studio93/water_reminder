import 'package:flutter/material.dart';

class UserSettings {
  final int dailyGoal;
  final TimeOfDay reminderStartTime;
  final TimeOfDay reminderEndTime;

  UserSettings({
    required this.dailyGoal,
    TimeOfDay? reminderStartTime,
    TimeOfDay? reminderEndTime,
  })  : reminderStartTime = reminderStartTime ?? const TimeOfDay(hour: 9, minute: 0),
        reminderEndTime = reminderEndTime ?? const TimeOfDay(hour: 21, minute: 0);
}
