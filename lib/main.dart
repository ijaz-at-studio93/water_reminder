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
  await NotificationService().init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WaterService()),
        ChangeNotifierProvider(create: (_) => SettingsService()),
      ],
      child: const MaterialApp(home: HomeScreen()),
    );
  }
}
