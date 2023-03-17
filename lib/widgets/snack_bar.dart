import 'package:flutter/material.dart';
import 'package:smart_attendance/widgets/styles.dart';

void showSnackBar({required String message, required BuildContext context}) {
  var snackBar = SnackBar(
    content: Text(
      message,
    ),
    backgroundColor: Palette.primary500,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
