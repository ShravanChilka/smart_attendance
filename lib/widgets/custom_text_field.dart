import 'package:flutter/material.dart';
import 'package:smart_attendance/widgets/styles.dart';

class CustomTextField extends StatelessWidget {
  final String title;
  final String hintText;
  final bool isPassword;
  final Icon? prefixIcon;
  final TextEditingController textController;

  const CustomTextField({
    Key? key,
    required this.title,
    required this.hintText,
    required this.textController,
    this.prefixIcon,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isPassword
        ? Padding(
            padding: const EdgeInsets.only(bottom: defaultPadding),
            child: TextField(
              obscureText: true,
              obscuringCharacter: "*",
              controller: textController,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: hintText,
                prefixIcon: prefixIcon,
                filled: true,
                fillColor: Palette.neutral100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(defaultRadius * 2),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(bottom: defaultPadding),
            child: TextField(
              controller: textController,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: hintText,
                prefixIcon: prefixIcon,
                filled: true,
                fillColor: Palette.neutral100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(defaultRadius * 2),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          );
  }
}
