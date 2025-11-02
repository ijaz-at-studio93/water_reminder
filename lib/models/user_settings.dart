import 'package:flutter/material.dart';

class UserSettings {
  final int dailyGoal;
  final TimeOfDay reminderStartTime;
  final TimeOfDay reminderEndTime;
  final bool isAllDayReminders;

  UserSettings({
    required this.dailyGoal,
    TimeOfDay? reminderStartTime,
    TimeOfDay? reminderEndTime,
    bool isAllDayReminders = false,
  })  : reminderStartTime = reminderStartTime ?? const TimeOfDay(hour: 9, minute: 0),
        reminderEndTime = reminderEndTime ?? const TimeOfDay(hour: 21, minute: 0),
        isAllDayReminders = isAllDayReminders;
}
