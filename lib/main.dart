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
  await settingsService.init();

  await notificationService.scheduleHourlyReminders(
    startTime: settingsService.userSettings.reminderStartTime,
    endTime: settingsService.userSettings.reminderEndTime,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: waterService),
        ChangeNotifierProvider.value(value: settingsService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // Renamed MainApp to MyApp
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Water Reminder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 57.0, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 16.0, height: 1.5),
          bodyMedium: TextStyle(fontSize: 14.0, height: 1.4),
          labelSmall: TextStyle(fontSize: 11.0, color: Colors.grey),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 57.0, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 16.0, height: 1.5),
          bodyMedium: TextStyle(fontSize: 14.0, height: 1.4),
          labelSmall: TextStyle(fontSize: 11.0, color: Colors.grey),
        ),
      ),
      themeMode: ThemeMode.system, // Follow system theme by default
      home: const HomeScreen(),
    );
  }
}
