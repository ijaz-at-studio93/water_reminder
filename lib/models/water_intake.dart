import 'package:hive/hive.dart';

part 'water_intake.g.dart';

@HiveType(typeId: 0)
class WaterIntake extends HiveObject {
  @HiveField(0)
  final int amount;

  @HiveField(1)
  final DateTime timestamp;

  WaterIntake({required this.amount, required this.timestamp});
}
