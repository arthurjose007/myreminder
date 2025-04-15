import 'package:flutter/material.dart';
import 'package:myreminder/utils/widgets/theme/theme.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final Function()? onTap;

  const CustomButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: primaryClr,
        ),
        child: Center(
            child: Text(
          label,
          style: const TextStyle(color: Colors.white),
        )),
      ),
    );
  }
}
