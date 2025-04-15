import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myreminder/features/model/controller/task_controller.dart';
import 'package:myreminder/features/model/addtask.dart';
import 'package:myreminder/utils/widgets/theme/theme.dart';
import 'package:myreminder/utils/widgets/appbar.dart';
import 'package:myreminder/utils/widgets/custominputfield.dart';

import '../../../utils/widgets/button.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TaskController _taskController = Get.put(TaskController());
  TextEditingController _titleController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _endTime = "9:30 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now());
  int _selectedRemind = 5;
  String _selectedRepeat = "None";
  List<String> repeatList = ["None", "Daily", "Weekly", "Monthly"];
  List<int> remindList = [5, 10, 20, 30, 40];
  int _selectedColor = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBarWidget(
        isaddScreen: true,
        onTap: () {
          Get.back();
        },
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Add Task",
                style: headingStyle,
              ),
              CustomInputField(
                title: "Title",
                hint: "Enter your title",
                Controller: _titleController,
              ),
              CustomInputField(
                title: "Note",
                hint: "Enter your note",
                Controller: _noteController,
              ),
              CustomInputField(
                title: "Date",
                hint: DateFormat('dd-MM-yyyy').format(_selectedDate).toString(),
                widget: IconButton(
                  icon: Icon(
                    Icons.calendar_month_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    print("icon");
                    _getDateFormUser();
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: CustomInputField(
                    title: "Start Date",
                    hint: _startTime,
                    widget: IconButton(
                      onPressed: () {
                        _getTimeFromUser(isStarTime: true);
                      },
                      icon: Icon(
                        Icons.access_time,
                        color: Colors.blue,
                      ),
                    ),
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: CustomInputField(
                    title: "End Date",
                    hint: _endTime,
                    widget: IconButton(
                      onPressed: () {
                        _getTimeFromUser(isStarTime: false);
                      },
                      icon: Icon(
                        Icons.access_time,
                        color: Colors.blue,
                      ),
                    ),
                  )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                  items: remindList.map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem<String>(
                      child: Text(
                        "${value.toString()} minutes early",
                      ),
                      value: value.toString(),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: "Remind",
                    hintText: "$_selectedRemind minutes early",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                  ),
                  icon:
                      const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  elevation: 4,
                  iconSize: 32,
                  style: subtitleStyle,
                  onChanged: (String? val) {
                    setState(() {
                      _selectedRemind = int.parse(val!);
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                  items:
                      repeatList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      child: Text(
                        "${value.toString()}",
                        style: TextStyle(color: Colors.grey),
                      ),
                      value: value.toString(),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: "Repeat",
                    hintText: "$_selectedRepeat",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 16),
                  ),
                  icon:
                      const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  elevation: 4,
                  iconSize: 32,
                  style: subtitleStyle,
                  onChanged: (String? val) {
                    setState(() {
                      _selectedRepeat = val!;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Color",
                        style: titleStyle,
                      ),
                      Wrap(
                        children: List<Widget>.generate(
                          3,
                          (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedColor = index;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: 8.0,
                                ),
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: index == 0
                                      ? primaryClr
                                      : index == 1
                                          ? pinkColor
                                          : yellowColor,
                                  child: _selectedColor == index
                                      ? Icon(
                                          Icons.done,
                                          color: Colors.white,
                                          size: 19,
                                        )
                                      : Container(),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  CustomButton(
                      label: "Create Task",
                      onTap: () {
                        _validateDate();
                      })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _addTaskToDb() async {
    int value = await _taskController.addTask(
        addTask: AddTask(
      note: _noteController.text,
      title: _titleController.text,
      date: DateFormat.yMd().format(_selectedDate).toString(),
      startTime: _startTime,
      endTime: _endTime,
      remind: _selectedRemind,
      repeat: _selectedRepeat,
      color: _selectedColor,
      isCompleted: 0,
    ));
    _taskController.getTasks();
    print("MY id id : $value");
  }

  _validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      //add to database
      _addTaskToDb();
      Get.back();
    } else if (_titleController.text.isNotEmpty ||
        _noteController.text.isEmpty) {
      Get.snackbar("Required", "Please fill the fields",
          snackPosition: SnackPosition.BOTTOM,
          icon: Icon(Icons.warning_amber_rounded));
    }
  }

  _getDateFormUser() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 60),
        lastDate: DateTime(DateTime.now().year + 20));

    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    } else {
      print("it's null or something is wrong");
    }
  }

  _getTimeFromUser({required bool isStarTime}) async {
    var _pickedTime = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_startTime.split(":")[0]),
        minute: int.parse(_startTime.split(":")[1].split("")[0]),
      ),
    );

    if (_pickedTime == null) {
      print("Time canceled");
      return;
    }

    // Format the time to 12-hour format with AM/PM
    String period = _pickedTime.period == DayPeriod.am ? 'AM' : 'PM';
    int hour = _pickedTime.hourOfPeriod;
    String minute = _pickedTime.minute.toString().padLeft(2, '0');
    String _formatedTime = '$hour:$minute $period';

    if (isStarTime) {
      setState(() {
        _startTime = _formatedTime;
      });
      print(_startTime);
    } else {
      setState(() {
        _endTime = _formatedTime;
      });
      print(_endTime);
    }
  }
}
