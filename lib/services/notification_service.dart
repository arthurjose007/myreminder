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
      // tz.initializeTimeZones();
      // final String currentTimeZone= await FlutterTimezone.getLocalTimezone();
      // tz.setLocalLocation(tz.getLocation(currentTimeZone));
      tz.initializeTimeZones();
      final String timeZoneName = await FlutterTimezone.getLocalTimezone();
      // Fix for India's timezone naming
      final String correctedTz = timeZoneName.replaceAll('Calcutta', 'Kolkata');
      tz.setLocalLocation(tz.getLocation(correctedTz));
      print('Timezone set to: ${tz.local.name}');

      //
      print("initialisation started");
      if (_isInitialized) return;

      // const AndroidInitializationSettings initializationSettingsAndroid =
      // AndroidInitializationSettings('@mipmap/ic_launcher');
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
  //Scheduled Notification time
  // scheduledNotification() async {
  //   print("this is scheduledNotification");
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //       0,
  //       'scheduled title',
  //       'theme changes 5 seconds ago',
  //       tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
  //       const NotificationDetails(
  //           android: AndroidNotificationDetails(
  //             'your channel id',
  //             'your channel name',
  //           ),
  //       ),
  //       uiLocalNotificationDateInterpretation:
  //       UILocalNotificationDateInterpretation.absoluteTime,
  //       androidAllowWhileIdle: true,
  //
  //
  //       androidScheduleMode: AndroidScheduleMode.alarmClock);
  // }
  // Future<void> scheduledNotification() async {
  //   print("Scheduling notification...");
  //
  //   try {
  //     // Initialize timezones if not already done
  //     if (!tz.timeZoneDatabase.isInitialized) {
  //       tz.initializeTimeZones();
  //     }
  //
  //     final scheduledTime = tz.TZDateTime.now(tz.local).add(Duration(seconds: 5));
  //     print("Notification scheduled for: $scheduledTime");
  //
  //     // Request necessary permissions (Android 12+)
  //     if (Platform.isAndroid) {
  //       await _requestNotificationPermissions();
  //     }
  //
  //     await flutterLocalNotificationsPlugin.zonedSchedule(
  //       0,
  //       'Scheduled Title',
  //       'This notification was scheduled 5 seconds ago',
  //       scheduledTime,
  //       const NotificationDetails(
  //         android: AndroidNotificationDetails(
  //           'daily_channel_id',
  //           'Daily Notification',
  //           channelDescription: 'Daily Notification Channel',
  //           importance: Importance.max,
  //           priority: Priority.high,
  //           playSound: true,
  //           enableVibration: true,
  //           colorized: true,
  //         ),
  //       ),
  //       // androidAllowWhileIdle: true, // Critical for Android
  //       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //       uiLocalNotificationDateInterpretation:
  //       UILocalNotificationDateInterpretation.absoluteTime,
  //       matchDateTimeComponents: DateTimeComponents.time,
  //
  //     );
  //     print("Notification scheduled successfully");
  //   } catch (e, stackTrace) {
  //     print("Error scheduling notification: $e");
  //     print("Stack trace: $stackTrace");
  //   }
  // }
  //
  //

  //other option for scheduleNotification
  // Future<void> scheduleNotification({
  //   int id = 0,
  //   String? title,
  //   String? body,
  //   Duration delay = const Duration(seconds: 5),
  // }) async {
  //   try {
  //     if (!_isInitialized) await initNotification();
  //     if (!await _checkAndroidPermissions()) return;
  //
  //     final scheduledTime = tz.TZDateTime.now(tz.local).add(delay);
  //     print('Scheduling notification for $scheduledTime');
  //
  //     await flutterLocalNotificationsPlugin.zonedSchedule(
  //       id,
  //       title ?? 'Scheduled Notification',
  //       body ?? 'This is a scheduled notification',
  //       scheduledTime,
  //       const NotificationDetails(
  //         android: AndroidNotificationDetails(
  //           'high_importance_channel',
  //           'High Importance Notifications',
  //           channelDescription: 'This channel is used for important notifications',
  //           importance: Importance.max,
  //           priority: Priority.high,
  //           playSound: true,
  //           enableVibration: true,
  //         ),
  //         iOS: DarwinNotificationDetails(),
  //       ),
  //       uiLocalNotificationDateInterpretation:
  //       UILocalNotificationDateInterpretation.absoluteTime,
  //       matchDateTimeComponents: DateTimeComponents.time,
  //       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //     );
  //
  //     print('Notification scheduled successfully');
  //   } catch (e, stackTrace) {
  //     print('Error scheduling notification: $e');
  //     print('Stack trace: $stackTrace');
  //   }
  // }

  // Future<bool> _checkAndroidPermissions() async {
  //   if (!Platform.isAndroid) return true;  // Skip if not Android
  //
  //   try {
  //     final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //     final androidInfo = await deviceInfo.androidInfo;
  //
  //     // For Android 13+ (API 33+) - Need notification permission
  //     if (androidInfo.version.sdkInt >= 33) {
  //       final status = await Permission.notification.status;
  //       if (!status.isGranted) {
  //         await Permission.notification.request();
  //       }
  //     }
  //
  //     // For Android 12+ (API 31+) - Need exact alarm permission
  //     if (androidInfo.version.sdkInt >= 31) {
  //       final status = await Permission.scheduleExactAlarm.status;
  //       if (!status.isGranted) {
  //         await Permission.scheduleExactAlarm.request();
  //       }
  //     }
  //
  //     return true;
  //   } catch (e) {
  //     print('Error checking permissions: $e');
  //     return false;
  //   }
  // }

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

//   Future<void> scheduleNotification({
//     int id = 1,
//     required String title,
//     required String body,
//     required int hour,
//     required int minute,
//   }) async {
//     //Get the current data/time in device's local timezone
//     final now = tz.TZDateTime.now(tz.local);
//     //Create a data/time for today at the specified hour/min
//     var scheduleData = tz.TZDateTime(
//       tz.local,
//       now.year,
//       now.month,
//       now.day,
//       hour,
//       minute,
//     );
// //Schedule the notification
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       scheduleData,
//       NotificationDetails(),
//       //ios specific :Use exact time specified (vs relaive time)
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       //Android specific :Allow notification while device is in low-power mode
//       androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
//       //Make notification repeat Daily at same time
//       matchDateTimeComponents: DateTimeComponents.time,
//     );
//     print("Notification Scheduled");
//   }
  //Cancel all notification

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
        hour,    // Use 24-hour format (15 for 3 PM)
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

      print('✅ Notification scheduled for: $scheduledTime');

      // Debug pending notifications
      final pending = await flutterLocalNotificationsPlugin.pendingNotificationRequests();
      print('Pending notifications: ${pending.length}');
      for (var n in pending) {
        print('Pending ID: ${n.id} - "${n.title}" at ${n.body}');
      }

    } catch (e, stackTrace) {
      print('❌ Error scheduling notification: $e');
      print(stackTrace);
    }
  }
  Future<void> debugNotificationSystem() async {
    print('\n=== NOTIFICATION DEBUG INFO ===');

    // 1. Check timezone
    print('Current timezone: ${tz.local.name}');
    print('Local time: ${tz.TZDateTime.now(tz.local)}');
    print('UTC time: ${DateTime.now().toUtc()}');

    // 2. Check initialization
    print('Notification initialized: $_isInitialized');

    // 3. Check Android channel
    if (Platform.isAndroid) {
      final channels = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.getNotificationChannels();
      print('Notification channels: $channels');

      // 4. Check permissions
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        final status = await Permission.notification.status;
        print('Notification permission: $status');
      }
    }

    // 5. Test immediate notification
    print('\nTesting immediate notification...');
    await showNotification(
      title: 'Test Notification',
      body: 'This should appear immediately',
    );
    print('Immediate notification triggered');

    print('\n=== END DEBUG INFO ===\n');
  }
Future<void> cancelAllNotificatons()async{
    await flutterLocalNotificationsPlugin.cancelAll();
}

}
