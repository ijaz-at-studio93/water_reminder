
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/services/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _dailyGoalController;

  @override
  void initState() {
    super.initState();
    _dailyGoalController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final settingsService = Provider.of<SettingsService>(context, listen: false);
    _dailyGoalController.text = settingsService.userSettings.dailyGoal.toString();
  }

  @override
  void dispose() {
    _dailyGoalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<SettingsService>(
        builder: (context, settingsService, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Goal',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _dailyGoalController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Daily Water Goal (ml)',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (value) {
                    final newGoal = int.tryParse(value);
                    if (newGoal != null && newGoal > 0) {
                      settingsService.updateDailyGoal(newGoal);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Daily goal updated!')),
                      );
                    }
                  },
                ),
                const SizedBox(height: 30),
                Text(
                  'Notification Settings',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 10),
                // TODO: Implement notification settings UI
                const Text('Notification settings UI will be implemented here.'),
              ],
            ),
          );
        },
      ),
    );
  }
}
