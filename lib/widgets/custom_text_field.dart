import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  String title;
  String hintText;
  bool isPassword;
  bool isTracking;
  TextEditingController textController;

  CustomTextField({
    Key? key,
    required this.title,
    required this.hintText,
    required this.textController,
    this.isPassword = false,
    this.isTracking = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(title, style: const TextStyle(color: Colors.white60)),
        isPassword
            ? TextField(
                obscureText: true,
                obscuringCharacter: "*",
                controller: textController,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText: hintText,
                ),
              )
            : TextField(
                controller: textController,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText: hintText,
                ),
              ),
      ],
    );
  }
}
