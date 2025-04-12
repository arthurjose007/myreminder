import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:myreminder/theme/theme.dart';

class CustomInputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? Controller;
  final Widget? widget;

  const CustomInputField(
      {super.key,
      required this.title,
      required this.hint,
      this.Controller,
      this.widget});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: titleStyle,
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 62,
          padding: const EdgeInsets.only(left: 14),
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  readOnly: widget==null?false:true,
                  autofocus: false,
                  cursorColor: Get.isDarkMode ? Colors.grey[100] : Colors.grey[600],
                  controller: Controller,
                  style: subHeadingStyle,
                  decoration: InputDecoration(
                    hintText: hint,
                    helperStyle: subHeadingStyle,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: context.theme.bottomAppBarColor, width: 0),
                    ),
                  ),
                ),
              ),
              widget==null?Container():Container(child: widget,)
            ],
          ),
        )
      ],
    );
  }
}
