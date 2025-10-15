import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/water_intake.dart';

class WaterService with ChangeNotifier {
  static const String _waterIntakeBoxName = 'water_intake';

  late Box<WaterIntake> _waterIntakeBox;

  List<WaterIntake> get waterIntakes => _waterIntakeBox.values.toList();

  WaterService() {
    _init();
  }

  Future<void> _init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(WaterIntakeAdapter());
    _waterIntakeBox = await Hive.openBox<WaterIntake>(_waterIntakeBoxName);
    notifyListeners();
  }

  Future<void> addWaterIntake(int amount) async {
    final newIntake = WaterIntake(amount: amount, timestamp: DateTime.now());
    await _waterIntakeBox.add(newIntake);
    notifyListeners();
  }

  double get todayIntake {
    final today = DateTime.now();
    return _waterIntakeBox.values
        .where(
          (intake) =>
              intake.timestamp.year == today.year &&
              intake.timestamp.month == today.month &&
              intake.timestamp.day == today.day,
        )
        .fold(0.0, (sum, item) => sum + item.amount);
  }
}
