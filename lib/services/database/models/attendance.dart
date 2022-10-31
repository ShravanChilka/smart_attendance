import 'package:smart_attendance/services/database/models/model_export.dart';

import '../g_sheet_api_service.dart';

class AttendanceModel {
  int id;
  int classId;
  int userId;
  String date;
  String time;
  double lat;
  double lng;

  AttendanceModel({
    this.id = 0,
    required this.classId,
    required this.userId,
    required this.date,
    required this.time,
    required this.lat,
    required this.lng,
  });

  @override
  String toString() {
    return "AttendanceModel { id : $id, classId : $classId, userId : $userId, date : $date, time : $time, lat : $lat, lng : $lng}";
  }

  factory AttendanceModel.fromGSheets(Map<String, dynamic> json) {
    return AttendanceModel(
      id: int.parse(json['id']),
      classId: int.parse(json['class_id']),
      userId: int.parse(json['user_id']),
      date: json['date'].toString(),
      time: json['time'].toString(),
      lat: double.parse(json['lat']),
      lng: double.parse(json['lng']),
    );
  }

  Map<String, dynamic> toGSheets() {
    return {
      'id': id,
      'class_id': classId,
      'user_id': userId,
      'date': date,
      'time': time,
      'lat': lat,
      'lng': lng,
    };
  }
}

class AttendanceHelper {
  AttendanceHelper._privateConstructor();

  static final AttendanceHelper _instance =
      AttendanceHelper._privateConstructor();

  factory AttendanceHelper() => _instance;

  Future<bool?> create({required AttendanceModel attendanceModel}) async {
    await GSheetApiService().init();
    final rowIndex = await GSheetApiService()
        .attendanceSheet
        ?.values
        .columnByKey('id')
        .then((value) => value?.length);
    attendanceModel.id = rowIndex != null ? rowIndex + 1 : 1;
    final out = await GSheetApiService()
        .attendanceSheet
        ?.values
        .map
        .insertRow(rowIndex != null ? rowIndex + 2 : 1, attendanceModel.toGSheets());
    return out;
  }

  Future<List<AttendanceModel>> getAll() async {
    await GSheetApiService().init();
    var out = await GSheetApiService()
        .attendanceSheet
        ?.values
        .map
        .allRows(fromRow: 2)
        .then((jsonList) => jsonList
            ?.map((json) => AttendanceModel.fromGSheets(json))
            .toList());
    return out ?? [];
  }

  Future<List<UserModel>> getUserByClassId({required int classId}) async {
    await GSheetApiService().init();
    List<UserModel> result = [];
    var out = await GSheetApiService()
        .attendanceSheet
        ?.values
        .map
        .allRows(fromRow: 2)
        .then((jsonList) => jsonList
            ?.map((json) => AttendanceModel.fromGSheets(json))
            .toList()) ?? [];
    for (AttendanceModel attendanceModel in out) {
      if (attendanceModel.classId == classId) {
        UserModel? user = await UserHelper().getById(attendanceModel.userId);
        if (user != null) result.add(user);
      }
    }
    return result;
  }
}
