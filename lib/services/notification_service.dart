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

    final scheduledTZ = tz.TZDateTime.from(scheduledTime, tz.local);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      title,
      body,
      scheduledTZ,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<bool> checkPermissions() async {
    try {
      final macOSImplementation = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin
          >();

      if (macOSImplementation != null) {
        final result = await macOSImplementation.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return result ?? false;
      }

      final iOSImplementation = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();

      if (iOSImplementation != null) {
        final result = await iOSImplementation.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return result ?? false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> scheduleHourlyReminders({
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    bool isAllDayReminders = false,
    int intervalMinutes = 60,
  }) async {
    await cancelAllNotifications();

    final hasPermission = await checkPermissions();
    if (!hasPermission) {
      return;
    }

    final now = DateTime.now();
    int notificationId = 0;
    int scheduledCount = 0;
    const maxScheduledNotifications = 120;

    if (isAllDayReminders) {
      DateTime currentTime = now.add(const Duration(minutes: 1));
      currentTime = DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        currentTime.hour,
        currentTime.minute,
      );

      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59);

      while (currentTime.isBefore(endOfDay) ||
          currentTime.isAtSameMomentAs(endOfDay)) {
        if (scheduledCount >= maxScheduledNotifications) {
          break;
        }

        await scheduleNotification(
          title: 'Time to drink water! 💧',
          body: 'Stay hydrated! Remember to drink some water.',
          scheduledTime: currentTime,
          notificationId: notificationId++,
        );

        scheduledCount++;
        currentTime = currentTime.add(Duration(minutes: intervalMinutes));
      }
    } else {
      DateTime startDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        startTime.hour,
        startTime.minute,
      );

      DateTime endDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        endTime.hour,
        endTime.minute,
      );

      if (endDateTime.isBefore(startDateTime)) {
        endDateTime = endDateTime.add(const Duration(days: 1));
      }

      if (startDateTime.isBefore(now)) {
        startDateTime = now.add(Duration(minutes: intervalMinutes));
        startDateTime = DateTime(
          startDateTime.year,
          startDateTime.month,
          startDateTime.day,
          startDateTime.hour,
          startDateTime.minute,
        );
      }

      DateTime currentTime = startDateTime;

      while ((currentTime.isBefore(endDateTime) ||
              currentTime.isAtSameMomentAs(endDateTime)) &&
          scheduledCount < maxScheduledNotifications) {
        await scheduleNotification(
          title: 'Time to drink water! 💧',
          body: 'Stay hydrated! Remember to drink some water.',
          scheduledTime: currentTime,
          notificationId: notificationId++,
        );

        scheduledCount++;
        currentTime = currentTime.add(Duration(minutes: intervalMinutes));
      }
    }
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
