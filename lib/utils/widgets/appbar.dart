import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final Function()? onTap;
  final bool isaddScreen ;
  const AppBarWidget({super.key, required this.onTap, this.isaddScreen = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
        leading: GestureDetector(
          onTap: onTap,
          child: isaddScreen
              ? Icon(Icons.arrow_back_ios_new)
              : Icon(
                  Get.isDarkMode
                      ? Icons.wb_sunny_outlined
                      : Icons.nightlight_round_outlined,
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                  size: 20,
                ),
        ),
        actions: const [
          Icon(
            Icons.person,
            size: 20,
          ),
          SizedBox(
            width: 20,
          )
        ]);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
