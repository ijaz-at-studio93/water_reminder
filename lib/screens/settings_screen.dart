import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/services/notification_service.dart';
import 'package:water_reminder/services/settings_service.dart';
import 'package:water_reminder/widgets/desktop_layout.dart';

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
    final settingsService = Provider.of<SettingsService>(
      context,
      listen: false,
    );
    _dailyGoalController.text = settingsService.userSettings.dailyGoal
        .toString();
  }

  @override
  void dispose() {
    _dailyGoalController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(
    BuildContext context,
    TimeOfDay initialTime,
    Function(TimeOfDay) onTimeSelected,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null) {
      onTimeSelected(picked);
    }
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('hh:mm a').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = DesktopLayout.isDesktop;

    return Scaffold(
      appBar: isDesktop ? null : AppBar(title: const Text('Settings')),
      body: Consumer<SettingsService>(
        builder: (context, settingsService, child) {
          final startTime = settingsService.userSettings.reminderStartTime;
          final endTime = settingsService.userSettings.reminderEndTime;

          return LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              final isSmallScreen = screenWidth < 600;
              final isLargeScreen = screenWidth >= 1200;

              final isDesktop = DesktopLayout.isDesktop;
              final horizontalPadding = isDesktop
                  ? 48.0
                  : isSmallScreen
                  ? 16.0
                  : isLargeScreen
                  ? 64.0
                  : 32.0;
              final maxWidth = isDesktop
                  ? 1000.0
                  : isLargeScreen
                  ? 800.0
                  : double.infinity;

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: isDesktop ? 48.0 : 16.0,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
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
                              const SnackBar(
                                content: Text('Daily goal updated!'),
                              ),
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
                      Card(
                        child: SwitchListTile(
                          title: const Text('All Day Reminders'),
                          subtitle: const Text(
                            'Receive reminders every hour throughout the day',
                          ),
                          value: settingsService.userSettings.isAllDayReminders,
                          onChanged: (bool value) async {
                            await settingsService.updateAllDayReminders(value);
                            final notificationService = NotificationService();
                            await notificationService.init();
                            await notificationService.scheduleHourlyReminders(
                              startTime: settingsService
                                  .userSettings
                                  .reminderStartTime,
                              endTime:
                                  settingsService.userSettings.reminderEndTime,
                              isAllDayReminders: value,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  value
                                      ? 'All day reminders enabled!'
                                      : 'Time range reminders enabled!',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (!settingsService.userSettings.isAllDayReminders) ...[
                        Text(
                          'Reminder Time Range',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Set the start and end time to receive hourly reminders.',
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (!settingsService.userSettings.isAllDayReminders)
                        isSmallScreen
                            ? Column(
                                children: [
                                  Card(
                                    child: ListTile(
                                      title: const Text('Start Time'),
                                      subtitle: Text(_formatTime(startTime)),
                                      leading: const Icon(Icons.access_time),
                                      onTap: () async {
                                        await _selectTime(context, startTime, (
                                          TimeOfDay newStartTime,
                                        ) async {
                                          if (newStartTime.hour <
                                                  endTime.hour ||
                                              (newStartTime.hour ==
                                                      endTime.hour &&
                                                  newStartTime.minute <
                                                      endTime.minute)) {
                                            await settingsService
                                                .updateReminderTimeRange(
                                                  startTime: newStartTime,
                                                  endTime: endTime,
                                                );
                                            final notificationService =
                                                NotificationService();
                                            await notificationService.init();
                                            await notificationService
                                                .scheduleHourlyReminders(
                                                  startTime: newStartTime,
                                                  endTime: endTime,
                                                  isAllDayReminders:
                                                      settingsService
                                                          .userSettings
                                                          .isAllDayReminders,
                                                );
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Reminder time updated!',
                                                ),
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Start time must be before end time!',
                                                ),
                                              ),
                                            );
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Card(
                                    child: ListTile(
                                      title: const Text('End Time'),
                                      subtitle: Text(_formatTime(endTime)),
                                      leading: const Icon(Icons.access_time),
                                      onTap: () async {
                                        await _selectTime(context, endTime, (
                                          TimeOfDay newEndTime,
                                        ) async {
                                          if (startTime.hour <
                                                  newEndTime.hour ||
                                              (startTime.hour ==
                                                      newEndTime.hour &&
                                                  startTime.minute <
                                                      newEndTime.minute)) {
                                            await settingsService
                                                .updateReminderTimeRange(
                                                  startTime: startTime,
                                                  endTime: newEndTime,
                                                );
                                            final notificationService =
                                                NotificationService();
                                            await notificationService.init();
                                            await notificationService
                                                .scheduleHourlyReminders(
                                                  startTime: startTime,
                                                  endTime: newEndTime,
                                                  isAllDayReminders:
                                                      settingsService
                                                          .userSettings
                                                          .isAllDayReminders,
                                                );
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Reminder time updated!',
                                                ),
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'End time must be after start time!',
                                                ),
                                              ),
                                            );
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: Card(
                                      child: ListTile(
                                        title: const Text('Start Time'),
                                        subtitle: Text(_formatTime(startTime)),
                                        leading: const Icon(Icons.access_time),
                                        onTap: () async {
                                          await _selectTime(context, startTime, (
                                            TimeOfDay newStartTime,
                                          ) async {
                                            if (newStartTime.hour <
                                                    endTime.hour ||
                                                (newStartTime.hour ==
                                                        endTime.hour &&
                                                    newStartTime.minute <
                                                        endTime.minute)) {
                                              await settingsService
                                                  .updateReminderTimeRange(
                                                    startTime: newStartTime,
                                                    endTime: endTime,
                                                  );
                                              final notificationService =
                                                  NotificationService();
                                              await notificationService.init();
                                              await notificationService
                                                  .scheduleHourlyReminders(
                                                    startTime: newStartTime,
                                                    endTime: endTime,
                                                    isAllDayReminders:
                                                        settingsService
                                                            .userSettings
                                                            .isAllDayReminders,
                                                  );
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Reminder time updated!',
                                                  ),
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Start time must be before end time!',
                                                  ),
                                                ),
                                              );
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Card(
                                      child: ListTile(
                                        title: const Text('End Time'),
                                        subtitle: Text(_formatTime(endTime)),
                                        leading: const Icon(Icons.access_time),
                                        onTap: () async {
                                          await _selectTime(context, endTime, (
                                            TimeOfDay newEndTime,
                                          ) async {
                                            if (startTime.hour <
                                                    newEndTime.hour ||
                                                (startTime.hour ==
                                                        newEndTime.hour &&
                                                    startTime.minute <
                                                        newEndTime.minute)) {
                                              await settingsService
                                                  .updateReminderTimeRange(
                                                    startTime: startTime,
                                                    endTime: newEndTime,
                                                  );
                                              final notificationService =
                                                  NotificationService();
                                              await notificationService.init();
                                              await notificationService
                                                  .scheduleHourlyReminders(
                                                    startTime: startTime,
                                                    endTime: newEndTime,
                                                    isAllDayReminders:
                                                        settingsService
                                                            .userSettings
                                                            .isAllDayReminders,
                                                  );
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Reminder time updated!',
                                                  ),
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'End time must be after start time!',
                                                  ),
                                                ),
                                              );
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
