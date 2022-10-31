import 'package:smart_attendance/services/database/models/model_export.dart';

import '../g_sheet_api_service.dart';

class UserModel {
  int id;
  String name;
  String email;
  String password;

  UserModel({
    this.id = 0,
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  String toString() {
    return "UserModel { id : $id, name : $name, email : $email, password : $password }";
  }

  factory UserModel.fromGSheets(Map<String, dynamic> json) {
    return UserModel(
      id: int.parse(json['id']),
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      password: json['password'] ?? "",
    );
  }

  Map<String, dynamic> toGSheets() {
    return {'id': id, 'name': name, 'email': email, 'password': password};
  }
}

class UserHelper {
  UserHelper._privateConstructor();

  static final UserHelper _instance = UserHelper._privateConstructor();

  factory UserHelper() => _instance;

  Future<bool?> create({required UserModel userModel}) async {
    await GSheetApiService().init();
    final rowIndex = await GSheetApiService()
        .userSheet
        ?.values
        .columnByKey('id')
        .then((value) => value?.length);
    userModel.id = rowIndex != null ? rowIndex + 1 : 1;
    final out = await GSheetApiService()
        .userSheet
        ?.values
        .map
        .insertRow(rowIndex != null ? rowIndex + 2 : 1, userModel.toGSheets());
    return out;
  }

  Future<List<UserModel>> getAll() async {
    await GSheetApiService().init();
    var out = await GSheetApiService()
        .userSheet
        ?.values
        .map
        .allRows(fromRow: 2)
        .then((jsonList) =>
        jsonList?.map((json) => UserModel.fromGSheets(json)).toList());
    return out ?? [];
  }

  Future<UserModel?> getById(int id) async {
    final map = await GSheetApiService().userSheet?.values.map.rowByKey(
      id,
      fromColumn: 1,
    );
    return map == null ? null : UserModel.fromGSheets(map);
  }
}
