import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_attendance/services/database/models/model_export.dart';
import 'package:smart_attendance/widgets/styles.dart';
import '../providers/providers_export.dart';
import '../services/location/location_service.dart';

class StartAttendanceScreen extends StatelessWidget {
  final ClassModel classModel;

  const StartAttendanceScreen({Key? key, required this.classModel})
      : super(key: key);

  static const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
  static Random random = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(random.nextInt(_chars.length))));

  @override
  Widget build(BuildContext context) {
    final attendanceStatusProvider =
        Provider.of<AttendanceStatusProvider>(context);
    final userListProvider = Provider.of<UserListProvider>(context);
    final loadingProvider = Provider.of<LoadingProvider>(context);

    void startAttendanceClickEvent({required ClassModel classModel}) async {
      loadingProvider.isLoading = true;
      final position = await LocationService().determinePosition();
      classModel.otp = getRandomString(6);
      classModel.lat = position.latitude;
      classModel.lng = position.longitude;
      classModel.isStarted = true;
      attendanceStatusProvider.classModel = classModel;
      ClassModelHelper().update(classModel: classModel);
      loadingProvider.isLoading = false;
    }

    void stopAttendanceClickEvent({required ClassModel classModel}) async {
      loadingProvider.isLoading = true;
      classModel.lat = 0.00;
      classModel.lng = 0.00;
      classModel.isStarted = false;
      attendanceStatusProvider.classModel = classModel;
      ClassModelHelper().update(classModel: classModel);
      loadingProvider.isLoading = false;
    }

    void syncClickEvent({required ClassModel classModel}) async {
      loadingProvider.isLoading = true;
      userListProvider.userList =
          await AttendanceHelper().getUserByClassId(classId: classModel.id);
      loadingProvider.isLoading = false;
    }

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(classModel.name),
        actions: [
          loadingProvider.isLoading
              ? Center(
                  child: Container(
                      margin: const EdgeInsets.only(right: 16),
                      width: 24,
                      height: 24,
                      child: const CircularProgressIndicator()),
                )
              : IconButton(
                  onPressed: () => syncClickEvent(classModel: classModel),
                  icon: const Icon(Icons.sync))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => classModel.isStarted
                  ? stopAttendanceClickEvent(classModel: classModel)
                  : startAttendanceClickEvent(classModel: classModel),
              child: SizedBox(
                width: size.width,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: attendanceStatusProvider.classModel.isStarted
                        ? const Text("Stop Attendance",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w600))
                        : const Text("Start Attendance",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "OTP",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                Text(
                  attendanceStatusProvider.classModel.otp,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Palette.secondary500,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: userListProvider.userList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const CircleAvatar(
                        backgroundColor: Palette.primary500,
                        child: Icon(Icons.person)),
                    title: Text(userListProvider.userList[index].name),
                    subtitle: Text(userListProvider.userList[index].email),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
