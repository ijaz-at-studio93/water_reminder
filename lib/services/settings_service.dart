import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/user_settings.dart';

class SettingsService with ChangeNotifier {
  static const String _dailyGoalKey = 'daily_goal';
  static const String _reminderStartHourKey = 'reminder_start_hour';
  static const String _reminderStartMinuteKey = 'reminder_start_minute';
  static const String _reminderEndHourKey = 'reminder_end_hour';
  static const String _reminderEndMinuteKey = 'reminder_end_minute';
  static const String _isAllDayRemindersKey = 'is_all_day_reminders';
  static const int _defaultDailyGoal = 2000;
  static const TimeOfDay _defaultStartTime = TimeOfDay(hour: 9, minute: 0);
  static const TimeOfDay _defaultEndTime = TimeOfDay(hour: 21, minute: 0);

  late SharedPreferences _prefs;
  late UserSettings _userSettings;

  UserSettings get userSettings => _userSettings;

  SettingsService() {
    _userSettings = UserSettings(
      dailyGoal: _defaultDailyGoal,
      isAllDayReminders: false,
    );
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final dailyGoal = _prefs.getInt(_dailyGoalKey) ?? _defaultDailyGoal;

    final startHour =
        _prefs.getInt(_reminderStartHourKey) ?? _defaultStartTime.hour;
    final startMinute =
        _prefs.getInt(_reminderStartMinuteKey) ?? _defaultStartTime.minute;
    final startTime = TimeOfDay(hour: startHour, minute: startMinute);

    final endHour = _prefs.getInt(_reminderEndHourKey) ?? _defaultEndTime.hour;
    final endMinute =
        _prefs.getInt(_reminderEndMinuteKey) ?? _defaultEndTime.minute;
    final endTime = TimeOfDay(hour: endHour, minute: endMinute);

    final isAllDayReminders = _prefs.getBool(_isAllDayRemindersKey) ?? false;

    _userSettings = UserSettings(
      dailyGoal: dailyGoal,
      reminderStartTime: startTime,
      reminderEndTime: endTime,
      isAllDayReminders: isAllDayReminders,
    );
    notifyListeners();
  }

  Future<void> updateDailyGoal(int newGoal) async {
    _userSettings = UserSettings(
      dailyGoal: newGoal,
      reminderStartTime: _userSettings.reminderStartTime,
      reminderEndTime: _userSettings.reminderEndTime,
      isAllDayReminders: _userSettings.isAllDayReminders,
    );
    await _prefs.setInt(_dailyGoalKey, newGoal);
    notifyListeners();
  }

  Future<void> updateReminderTimeRange({
    required TimeOfDay startTime,
    required TimeOfDay endTime,
  }) async {
    _userSettings = UserSettings(
      dailyGoal: _userSettings.dailyGoal,
      reminderStartTime: startTime,
      reminderEndTime: endTime,
      isAllDayReminders: _userSettings.isAllDayReminders,
    );
    await _prefs.setInt(_reminderStartHourKey, startTime.hour);
    await _prefs.setInt(_reminderStartMinuteKey, startTime.minute);
    await _prefs.setInt(_reminderEndHourKey, endTime.hour);
    await _prefs.setInt(_reminderEndMinuteKey, endTime.minute);
    notifyListeners();
  }

  Future<void> updateAllDayReminders(bool isAllDay) async {
    _userSettings = UserSettings(
      dailyGoal: _userSettings.dailyGoal,
      reminderStartTime: _userSettings.reminderStartTime,
      reminderEndTime: _userSettings.reminderEndTime,
      isAllDayReminders: isAllDay,
    );
    await _prefs.setBool(_isAllDayRemindersKey, isAllDay);
    notifyListeners();
  }
}
