import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/models/water_intake.dart';
import 'package:water_reminder/screens/home_screen.dart';
import 'package:water_reminder/services/notification_service.dart';
import 'package:water_reminder/services/settings_service.dart';
import 'package:water_reminder/services/water_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(WaterIntakeAdapter());

  final notificationService = NotificationService();
  await notificationService.init();

  final waterService = WaterService();
  await waterService.init(); // Await the init method of WaterService

  final settingsService = SettingsService();
  await settingsService.init(); // Await the init method of SettingsService

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: waterService),
        ChangeNotifierProvider.value(value: settingsService),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeScreen());
  }
}
