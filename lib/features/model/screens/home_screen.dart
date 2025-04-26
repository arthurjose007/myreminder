import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myreminder/features/model/addtask.dart';
import 'package:myreminder/features/model/controller/task_controller.dart';
import 'package:myreminder/features/model/screens/addtaskscreen.dart';
import 'package:myreminder/features/model/services/service.dart';
import 'package:myreminder/utils/widgets/appbar.dart';
import 'package:myreminder/utils/widgets/tasktail.dart';
import 'package:timezone/timezone.dart' as tz;

import '../services/notification_service.dart';
import '../../../utils/widgets/theme/theme.dart';
import 'package:flutter/material.dart';

import '../../../utils/widgets/button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var notifyHelper;
  DateTime selecteddate = DateTime.now();
  final _taskController = Get.put(TaskController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper = NotificationService();
    notifyHelper.initNotification();
    // notifyHelper.initNotification().then((_) {
    //   notifyHelper.debugNotificationSystem(); // Add this line
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
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

          // NotificationService().scheduleNotification(
          //   title: "title",
          //   body: "body",
          //   hour: now.hour,
          //   minute: now.minute + 1,
          // );
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
          _showTasks(),
        ],
      ),
    );
  }

  _showTasks() {
    return Expanded(child: Obx(() {
      return ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (context, index) {
            final task = _taskController.taskList[index];
            // _taskController.delete(_taskController.taskList[index]);
            // _taskController.getTasks();
            return AnimationConfiguration.staggeredList(
              position: index,
              child: SlideAnimation(
                child: FadeInAnimation(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          print("Tapped");
                          _showBottomSheet(context, task);
                        },
                        child: TaskTile(_taskController.taskList[index]),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
    }));
  }

  _showBottomSheet(BuildContext context, AddTask task) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        width: MediaQuery.of(context).size.width,
        height: task.isCompleted == 1
            ? MediaQuery.of(context).size.height * 0.04
            : MediaQuery.of(context).size.height * 0.32,
        color: Get.isDarkMode ? darkGreColor : Colors.white,
        child: Column(
          children: [
            Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
                )),
            const SizedBox(
              height: 7,
              width: 200,
            ),
            task.isCompleted == 1
                ? const SizedBox()
                : _bottomSheetButton(
                    lable: "Task Completed",
                    onTap: () {

                    },
                    Clr: primaryClr,
                  ),
            const SizedBox(
              height: 10,
            ),
            _bottomSheetButton(
              lable: "Delete Task",
              onTap: () {
                _taskController.delete(task);
                _taskController.getTasks();
                Get.back();},
              Clr: Colors.red,
            ),
            const SizedBox(
              height: 10,
            ),
            _bottomSheetButton(
              lable: "Close",
              onTap: () {
                Get.back();
              },
              Clr: Colors.red,
              isColse: true,
            )
          ],
        ),
      ),
    );
  }

  _bottomSheetButton({
    required String lable,
    required Function() onTap,
    required Color Clr,
    bool isColse = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 4,
        ),
        height: 60,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isColse == true
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : Clr,
          ),
          borderRadius: BorderRadius.circular(20),
          // color: Colors.red,

          color: isColse == true ? Colors.transparent : Clr,
        ),
        child: Center(
            child: Text(
          lable,
          style:
              isColse ? titleStyle : titleStyle.copyWith(color: Colors.white),

        )),
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
