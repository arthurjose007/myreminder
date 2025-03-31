import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl/intl.dart';
import 'package:myreminder/services/service.dart';
 import 'package:timezone/timezone.dart' as tz;

import '../services/notification_service.dart';
import '../theme/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var notifyHelper;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // notifyHelper=NotificationService();
    // notifyHelper.initializeNotifications();
    notifyHelper = NotificationService();
    notifyHelper.initNotification();
    // notifyHelper.scheduledNotification();
    notifyHelper.initNotification().then((_) {
      notifyHelper.debugNotificationSystem();  // Add this line
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      appBar: _appBar(context),
      body: Column(
        children: [
          Row(children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column
                (
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text(DateFormat.yMMMMd().format(DateTime.now()),
                 style: subHeadingStyle,
                ),
                Text("Today",
                  style: headingStyle,
                ),
              ],),
            )

          ],),
          Container(
            child: Text(''),
          )
        ],
      ),
    );
  }

  _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchTheme();
          // NotificationService().displayNotification(title: "Theme changed", body: "hello");
          // print("object");
          NotificationService().showNotification(
              title: "Theme Changed",
              body: Get.isDarkMode
                  ? "Activated Light Theme"
                  : "Activated Dark Theme");
          // notifyHelper.scheduledNotification();
          final now = tz.TZDateTime.now(tz.local);

          NotificationService().scheduleNotification(
            title: "title",
            body: "body",
            hour: now.hour,
            minute: now.minute+1,
          );
          // NotificationService().scheduleNotification(
          //   title: "title2",
          //   body: "body",
          //   hour: 9,
          //   minute: 30,
          // );
        },
        child: Icon( Get.isDarkMode
            ?
          Icons.wb_sunny_outlined:Icons.nightlight_round_outlined,
          color: Get.isDarkMode?Colors.white:Colors.black,
          size: 20,
        ),
      ),
      actions: [
        Icon(
          Icons.person,
          size: 20,
        ),
        SizedBox(
          width: 20,
        )
      ],
    );
  }
}



