import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'package:get/get_core/src/get_main.dart';
import 'package:myreminder/features/model/addtask.dart';
import 'package:get/get.dart';
import '../screens/secondpage.dart';

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // @pragma('vm:entry-point')
  // void notificationTapBackground(NotificationResponse response) {
  //   // Simple handling or use GetX for navigation
  //   if (response.payload != null) {
  //     Get.to(() => SecondScreen(response.payload!));
  //   }
  // }
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
        onDidReceiveNotificationResponse:(
            NotificationResponse response
        ){
          _onNotificationTapped(response);
        }
        // onDidReceiveBackgroundNotificationResponse: _onNotificationTapped
      );


      // Create notification channel for Android 8.0+
      await _createNotificationChannel();

      _isInitialized = true;
    } catch (e) {
      print("An error occurred in init: $e");
    }
  }
  // void _onNotificationTapped(NotificationResponse response) {
  //   // Your existing foreground handling
  //   if (response.payload != null) {
  //     Get.to(() => SecondScreen(response.payload!));
  //   }
  // }

// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    print('Notification tapped! Payload: ${response.payload}');

    // You can use Navigator to open a specific screen based on the payload
    // Example: Navigate to a task details screen if payload contains task ID
    if (response.payload != null && response.payload!.isNotEmpty) {

      selectNotification(response.payload.toString());
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


  Future selectNotification(String payload) async {
    if (payload != null) {
      print('notification payload: $payload');
    } else {
      print("Notification Done");
    }

    if(payload=="Theme Changed"){
      //going nowhere
    }else{
      Get.to(()=>SecondScreen(payload));
    }
  }

  // SHOW NOTIFICATION
  Future<void> showNotification(
      {int id = 0, String? title, String? body}) async {
    print("show changed color");

    await flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        notificationDetails(),
        payload: "Theme Changed"// Use your custom details here
    );
  }



  Future<void> scheduleNotification(String title,String body,{
    required int hour,
    required int minute,
    AddTask? task,
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
          task!.id!.toInt(),
          task.title,
          task.date,
          // tz.TZDateTime.now(tz.local).add(Duration(minutes: minute,hours: hour )),
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
          payload: "${task.title}|${task.note}"
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



  //Cancel all notification

  Future<void> cancelAllNotificatons() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}




