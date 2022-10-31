import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_attendance/services/database/models/model_export.dart';
import 'package:smart_attendance/widgets/custom_text_field.dart';
import '../providers/loading_provider.dart';
import '../services/location/location_service.dart';

class MarkAttendanceScreen extends StatelessWidget {
  final ClassModel classModel;
  final UserModel userModel;

  MarkAttendanceScreen(
      {Key? key, required this.classModel, required this.userModel})
      : super(key: key);

  final _otpTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final loadingProvider = Provider.of<LoadingProvider>(context);

    void showSnackBar({required String message}) {
      var snackBar = SnackBar(
        content: Text(
          message,
        ),
        backgroundColor: Colors.orangeAccent,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    void markAttendanceClickEvent(
        {required ClassModel classModel, required UserModel userModel}) async {
      loadingProvider.isLoading = true;
      final position = await LocationService().determinePosition();
      ClassModel? classM = await ClassModelHelper().getById(classModel.id);

      if (classM != null) {
        if (classM.isStarted) {
          if (position.latitude - 0.00050 <= classModel.lat &&
              classModel.lat <= position.latitude + 0.00050 &&
              position.longitude - 0.00050 <= classModel.lng &&
              classModel.lng <= position.longitude + 0.0050) {
            if (_otpTextController.text == classModel.otp &&
                classModel.otp != "NA") {
              await AttendanceHelper().create(
                  attendanceModel: AttendanceModel(
                      classId: classModel.id,
                      userId: userModel.id,
                      date: DateFormat("yyyy-MM-dd").format(DateTime.now()),
                      time: DateFormat("hh:mm:ss").format(DateTime.now()),
                      lat: position.latitude,
                      lng: position.longitude));
              debugPrint("Attendance Marked");
              showSnackBar(message: "Attendance Marked");
            } else {
              debugPrint("Invalid OTP");
              showSnackBar(message: "Invalid OTP");
            }
          } else {
            debugPrint("Out of the allotted location");
            showSnackBar(message: "Out of the allotted location");
          }
        } else {
          debugPrint("Attendance has not started yet");
          showSnackBar(message: "Attendance has not started yet");
        }
      }
      loadingProvider.isLoading = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(classModel.name),
        actions: [
          Visibility(
            visible: loadingProvider.isLoading,
            child: Center(
              child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  width: 24,
                  height: 24,
                  child: const CircularProgressIndicator()),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomTextField(
                title: "OTP",
                hintText: "Enter the OTP",
                textController: _otpTextController),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => markAttendanceClickEvent(
                  classModel: classModel, userModel: userModel),
              child: SizedBox(
                width: size.width,
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    child: Text(
                      "Mark Attendance",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
