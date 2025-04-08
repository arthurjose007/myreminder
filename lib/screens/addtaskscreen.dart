import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myreminder/theme/theme.dart';
import 'package:myreminder/widgets/appbar.dart';
import 'package:myreminder/widgets/custominputfield.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  DateTime _selectedDate = DateTime.now();
  String _endTime = "9:30 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now());
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 20, 30, 40];
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
              const CustomInputField(title: "Title", hint: "Enter your title"),
              const CustomInputField(title: "Note", hint: "Enter your note"),
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
                      icon: Icon(Icons.access_time),
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
              CustomInputField(
                title: "Remind",
                hint: "$_selectedRemind minutes early",
                widget:
                DropdownButton(

                  onChanged: (String? val) {
                    setState(() {
                      _selectedRemind=int.parse( val!);
                    });
                  },
                  icon:const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  elevation: 4,
                  iconSize: 32,
                  underline: Container(height: 0,),
                  style: subtitleStyle,
                  items: remindList.map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem<String>(
                      child: Text(
                        value.toString(),
                      ),
                      value: value.toString(),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
    String _formatedTime = _pickedTime.toString();
    if (_pickedTime == null) {
      print("Time canceled");
    } else if (isStarTime == true) {
      setState(() {
        _startTime = _formatedTime;
      });
    } else if (isStarTime == false) {
      setState(() {
        _endTime = _formatedTime;
      });
    }
  }
}
