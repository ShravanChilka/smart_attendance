import 'package:flutter/material.dart';
import 'package:smart_attendance/services/database/models/class.dart';

class AttendanceStatusProvider with ChangeNotifier{
  late ClassModel _classModel ;

  ClassModel get classModel => _classModel;

  set classModel(ClassModel value) {
    _classModel = value;
    notifyListeners();
  }
}