import 'package:flutter/material.dart';
import 'package:smart_attendance/services/database/models/class.dart';

class ClassListProvider with ChangeNotifier{
  List<ClassModel> _classList = [];

  List<ClassModel> get classList => _classList;

  set classList(List<ClassModel> value) {
    _classList = value;
    notifyListeners();
  }
}