import 'package:flutter/cupertino.dart';
import 'package:gsheets/gsheets.dart';
import 'constants.dart';

class GSheetApiService {
  final GSheets _gSheets = GSheets(Constant.credentials);
  Spreadsheet? _spreadsheet;

  GSheetApiService._privateConstructor();

  static final GSheetApiService _instance =
      GSheetApiService._privateConstructor();

  factory GSheetApiService() => _instance;

  // All worksheets
  Worksheet? _userSheet;
  Worksheet? _classSheet;
  Worksheet? _attendanceSheet;

  Worksheet? get attendanceSheet => _attendanceSheet;

  Worksheet? get classSheet => _classSheet;

  Worksheet? get userSheet => _userSheet;

  Future<void> init() async {
    try {
      _spreadsheet ??= await _gSheets.spreadsheet(Constant.spreadsheetId);

      _userSheet ??= _spreadsheet?.worksheetByTitle('user');
      _classSheet ??= _spreadsheet?.worksheetByTitle('class');
      _attendanceSheet ??= _spreadsheet?.worksheetByTitle('attendance');
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
