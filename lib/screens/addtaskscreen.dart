import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myreminder/widgets/appbar.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({super.key});

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
    );
  }
}
