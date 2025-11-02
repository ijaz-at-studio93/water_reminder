import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    final DarwinInitializationSettings initializationSettingsMacOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
          macOS: initializationSettingsMacOS,
        );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledTime,
    required int notificationId,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'water_reminder_channel',
          'Water Reminder',
          channelDescription: 'Channel for Water Reminder notifications',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
        );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: darwinNotificationDetails,
      macOS: darwinNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> scheduleHourlyReminders({
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    bool isAllDayReminders = false,
  }) async {
    await cancelAllNotifications();

    final now = DateTime.now();
    int notificationId = 0;

    if (isAllDayReminders) {
      for (int hour = 0; hour < 24; hour++) {
        DateTime scheduledTime = DateTime(
          now.year,
          now.month,
          now.day,
          hour,
          0,
        );

        if (scheduledTime.isBefore(now)) {
          scheduledTime = scheduledTime.add(const Duration(days: 1));
        }

        await scheduleNotification(
          title: 'Time to drink water! 💧',
          body: 'Stay hydrated! Remember to drink some water.',
          scheduledTime: scheduledTime,
          notificationId: notificationId++,
        );
      }
    } else {
      int currentHour = startTime.hour;
      final reminderMinute = startTime.minute;

      while (currentHour <= endTime.hour) {
        final shouldSchedule =
            currentHour < endTime.hour ||
            (currentHour == endTime.hour && reminderMinute <= endTime.minute);

        if (shouldSchedule) {
          final notificationTime = TimeOfDay(
            hour: currentHour,
            minute: reminderMinute,
          );

          DateTime scheduledTime = DateTime(
            now.year,
            now.month,
            now.day,
            notificationTime.hour,
            notificationTime.minute,
          );

          if (scheduledTime.isBefore(now)) {
            scheduledTime = scheduledTime.add(const Duration(days: 1));
          }

          await scheduleNotification(
            title: 'Time to drink water! 💧',
            body: 'Stay hydrated! Remember to drink some water.',
            scheduledTime: scheduledTime,
            notificationId: notificationId++,
          );
        }

        currentHour++;
      }
    }
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
