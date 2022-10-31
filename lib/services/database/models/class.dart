import '../g_sheet_api_service.dart';

class ClassModel {
  int id;
  String name;
  double lat, lng;
  bool isStarted;
  String otp;

  ClassModel({
    this.id = 0,
    required this.name,
    this.lat = 0.00,
    this.lng = 0.00,
    this.isStarted = false,
    this.otp = "NA",
  });

  @override
  String toString() {
    return "ClassModel { id : $id, name : $name, lat : $lat, lng : $lng, isStarted : $isStarted }";
  }

  factory ClassModel.fromGSheets(Map<String, dynamic> json) {
    return ClassModel(
      id: int.parse(json['id']),
      name: json['name'] ?? "",
      otp: json['otp'] ?? "NA",
      lat: double.parse(json['lat']),
      lng: double.parse(json['lng']),
      isStarted: json['is_started'] == "true" ? true : false,
    );
  }

  Map<String, dynamic> toGSheets() {
    return {
      'id': id,
      'name': name,
      'lat': lat,
      'lng': lng,
      'is_started': isStarted,
      'otp' : otp,
    };
  }
}

class ClassModelHelper {
  ClassModelHelper._privateConstructor();

  static final ClassModelHelper _instance =
      ClassModelHelper._privateConstructor();

  factory ClassModelHelper() => _instance;

  Future<bool?> create({required ClassModel classModel}) async {
    await GSheetApiService().init();
    final rowIndex = await GSheetApiService()
        .classSheet
        ?.values
        .columnByKey('id')
        .then((value) => value?.length);
    classModel.id = rowIndex != null ? rowIndex + 1 : 1;
    final out = await GSheetApiService()
        .classSheet
        ?.values
        .map
        .insertRow(rowIndex != null ? rowIndex + 2 : 1, classModel.toGSheets());
    return out;
  }

  Future<List<ClassModel>> getAll() async {
    await GSheetApiService().init();
    var out = await GSheetApiService()
        .classSheet
        ?.values
        .map
        .allRows(fromRow: 2)
        .then((jsonList) =>
            jsonList?.map((json) => ClassModel.fromGSheets(json)).toList());
    return out ?? [];
  }

  Future<bool?> update({required ClassModel classModel}) async {
    await GSheetApiService().init();
    final out = await GSheetApiService()
        .classSheet
        ?.values
        .map
        .insertRowByKey(classModel.id, classModel.toGSheets());
    return out;
  }

  Future<ClassModel?> getById(int id) async {
    final map = await GSheetApiService().classSheet?.values.map.rowByKey(
          id,
          fromColumn: 1,
        );
    return map == null ? null : ClassModel.fromGSheets(map);
  }
}
