import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/services/settings_service.dart';
import 'package:water_reminder/services/water_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Reminder'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings screen
            },
          ),
        ],
      ),
      body: Consumer2<WaterService, SettingsService>(
        builder: (context, waterService, settingsService, child) {
          final dailyGoal = settingsService.userSettings.dailyGoal;
          final todayIntake = waterService.todayIntake;
          final progress = todayIntake / dailyGoal;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 10,
                        backgroundColor: Colors.blue.shade100,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${todayIntake.toInt()} ml',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          'of ${dailyGoal.toInt()} ml',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => waterService.addWaterIntake(200),
                      child: const Text('200 ml'),
                    ),
                    ElevatedButton(
                      onPressed: () => waterService.addWaterIntake(300),
                      child: const Text('300 ml'),
                    ),
                    ElevatedButton(
                      onPressed: () => waterService.addWaterIntake(500),
                      child: const Text('500 ml'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _showCustomAmountDialog(context, waterService);
                  },
                  child: const Text('Custom Amount'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showCustomAmountDialog(BuildContext context, WaterService waterService) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Log Custom Amount'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Amount in ml'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = int.tryParse(controller.text);
                if (amount != null && amount > 0) {
                  waterService.addWaterIntake(amount);
                  Navigator.pop(context);
                }
              },
              child: const Text('Log'),
            ),
          ],
        );
      },
    );
  }
}