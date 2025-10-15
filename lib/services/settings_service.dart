import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../models/user_settings.dart';

class SettingsService with ChangeNotifier {
  static const String _dailyGoalKey = 'daily_goal';
  static const int _defaultDailyGoal = 2000; // Default goal in ml

  late SharedPreferences _prefs;
  late UserSettings _userSettings;

  UserSettings get userSettings => _userSettings;

  SettingsService() {
    _userSettings = UserSettings(dailyGoal: _defaultDailyGoal);
  }

  Future<void> init() async {
    // Public init method
    _prefs = await SharedPreferences.getInstance();
    final dailyGoal = _prefs.getInt(_dailyGoalKey) ?? _defaultDailyGoal;
    _userSettings = UserSettings(dailyGoal: dailyGoal);
    notifyListeners();
  }

  Future<void> updateDailyGoal(int newGoal) async {
    _userSettings = UserSettings(dailyGoal: newGoal);
    await _prefs.setInt(_dailyGoalKey, newGoal);
    notifyListeners();
  }
}
