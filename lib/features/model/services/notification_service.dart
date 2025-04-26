import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // INITIALIZE
  Future<void> initNotification() async {
    try {
      tz.initializeTimeZones();
      final String timeZoneName = await FlutterTimezone.getLocalTimezone();
      // Fix for India's timezone naming
      final String correctedTz = timeZoneName.replaceAll('Calcutta', 'Kolkata');
      tz.setLocalLocation(tz.getLocation(correctedTz));
      print('Timezone set to: ${tz.local.name}');

      //
      print("initialisation started");
      if (_isInitialized) return;

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (details) {
          // Handle notification tap if needed
        },
      );

      // Create notification channel for Android 8.0+
      await _createNotificationChannel();

      _isInitialized = true;
    } catch (e) {
      print("An error occurred in init: $e");
    }
  }

  // Create notification channel for Android
  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'daily_channel_id', // id
      'Daily Notification', // title
      description: 'Daily Notification Channel', // description
      importance: Importance.max,
      playSound: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // NOTIFICATION DETAILS
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel_id',
        'Daily Notification',
        channelDescription: 'Daily Notification Channel',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  // SHOW NOTIFICATION
  Future<void> showNotification(
      {int id = 0, String? title, String? body}) async {
    print("show changed color");

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails(), // Use your custom details here
    );
  }
  /*
  schedule a notification at a specified time(eg.11pm)
    - hour (0-23)
    - minute(0-59)
   */

  Future<void> scheduleNotification({
    int id = 1,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    try {
      if (!_isInitialized) await initNotification();

      final now = tz.TZDateTime.now(tz.local);
      print('Current local time: $now');

      // Fix time calculation - use 24-hour format
      var scheduledTime = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour, // Use 24-hour format (15 for 3 PM)
        minute,
      );
      print('Original scheduled time: $scheduledTime');

      if (scheduledTime.isBefore(now)) {
        scheduledTime = scheduledTime.add(const Duration(days: 1));
        print('Adjusted scheduled time: $scheduledTime');
      }

      // Enhanced Android permission handling
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        print('Android SDK: ${androidInfo.version.sdkInt}');

        // Critical for Android 12+
        if (androidInfo.version.sdkInt >= 31) {
          final status = await Permission.scheduleExactAlarm.status;
          if (!status.isGranted) {
            await Permission.scheduleExactAlarm.request();
          }
        }

        // Disable battery optimization
        // if (!await Permission.ignoreBatteryOptimizations.isGranted) {
        //   await Permission.ignoreBatteryOptimizations.request();
        // }
      }

      // Schedule with exact timing
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_channel_id',
            'Daily Notification',
            channelDescription: 'Daily Notification Channel',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            visibility: NotificationVisibility.public,
            timeoutAfter: 0, // Never timeout
          ),
          iOS: DarwinNotificationDetails(),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      print('Notification scheduled for: $scheduledTime');

      // Debug pending notifications
      final pending =
          await flutterLocalNotificationsPlugin.pendingNotificationRequests();
      print('Pending notifications: ${pending.length}');
      for (var n in pending) {
        print('Pending ID: ${n.id} - "${n.title}" at ${n.body}');
      }
    } catch (e, stackTrace) {
      print('Error scheduling notification: $e');
      print(stackTrace);
    }
  }


  Future<void> cancelAllNotificatons() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
