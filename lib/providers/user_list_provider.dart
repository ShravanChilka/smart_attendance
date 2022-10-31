import 'package:flutter/material.dart';
import 'package:smart_attendance/services/database/models/user.dart';

class UserListProvider with ChangeNotifier{
  List<UserModel> _userList = [];

  List<UserModel> get userList => _userList;

  set userList(List<UserModel> value) {
    _userList = value;
    notifyListeners();
  }
}