import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myreminder/screens/addtaskscreen.dart';
import 'package:myreminder/services/service.dart';
import 'package:myreminder/widgets/appbar.dart';
import 'package:myreminder/widgets/button.dart';
import 'package:timezone/timezone.dart' as tz;

import '../services/notification_service.dart';
import '../theme/theme.dart';
import 'package:flutter/material.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   DateTime _selectedDate = DateTime.now();
//   DateTime _currentMonth = DateTime.now();
//
//   void _nextMonth() {
//     setState(() {
//       _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
//     });
//   }
//
//   void _prevMonth() {
//     setState(() {
//       _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
//     });
//   }
//
//   void _selectYear() async {
//     final DateTime? picked = await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Select Year"),
//           content: SizedBox(
//             width: 300,
//             height: 300,
//             child: YearPicker(
//               firstDate: DateTime(DateTime.now().year - 10),
//               lastDate: DateTime(DateTime.now().year + 10),
//               initialDate: _currentMonth,
//               selectedDate: _currentMonth,
//               onChanged: (DateTime dateTime) {
//                 setState(() {
//                   _currentMonth = DateTime(dateTime.year, _currentMonth.month);
//                 });
//                 Navigator.pop(context);
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).secondaryHeaderColor,
//       body: Column(
//         children: [
//           SizedBox(height: 40,),
//           // Month/Year selector
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 IconButton(
//                     onPressed: _prevMonth,
//                     icon: Icon(Icons.chevron_left, color: primaryClr)),
//                 TextButton(
//                   onPressed: _selectYear,
//                   child: Text(
//                     DateFormat('MMMM yyyy').format(_currentMonth),
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                     onPressed: _nextMonth,
//                     icon: Icon(Icons.chevron_right, color: primaryClr)),
//               ],
//             ),
//           ),
//           // Date picker
//           Container(
//             child: DatePicker(
//               _currentMonth,
//               height: 100,
//               width: 80,
//               initialSelectedDate: _selectedDate,
//               selectionColor: primaryClr,
//               selectedTextColor: Colors.white,
//               dateTextStyle: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey,
//               ),
//               onDateChange: (date) {
//                 setState(() {
//                   _selectedDate = date;
//                 });
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var notifyHelper;
  DateTime selecteddate = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper = NotificationService();
    notifyHelper.initNotification();
    // notifyHelper.scheduledNotification();
    notifyHelper.initNotification().then((_) {
      notifyHelper.debugNotificationSystem(); // Add this line
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      appBar: AppBarWidget(
        onTap: () {
          ThemeService().switchTheme();
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
            minute: now.minute + 1,
          );
          // NotificationService().scheduleNotification(
          //   title: "title2",
          //   body: "body",
          //   hour: 9,
          //   minute: 30,
          // );
        },
      ),
      //_appBar(context),
      body: Column(
        children: [
          _appTapBar(),
          _addDateBar(),
        ],
      ),
    );
  }

  _addDateBar() {
    return SizedBox(
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey)),
        dayTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey)),
        monthTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey)),
        onDateChange: (DateTime date) {
          selecteddate = date;
          print(selecteddate);
        },
      ),
    );
  }

  _appTapBar() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
        left: 15,
        right: 15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text(
                  "Today",
                  style: headingStyle,
                ),
              ],
            ),
          ),
          CustomButton(
              label: "+ Add Task",
              onTap: () {
                Get.to(AddTaskScreen());
              }),
        ],
      ),
    );
  }

}
