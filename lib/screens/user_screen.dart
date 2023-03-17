import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_attendance/screens/screens_export.dart';
import 'package:smart_attendance/services/database/models/model_export.dart';
import '../providers/providers_export.dart';
import '../widgets/styles.dart';
import 'login_screen_new.dart';

class UserScreen extends StatelessWidget {
  final UserModel userModel;

  const UserScreen({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loadingProvider = Provider.of<LoadingProvider>(context);
    final classListProvider = Provider.of<ClassListProvider>(context);

    navigateToMarkAttendance({required ClassModel classModel}) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MarkAttendanceScreen(
              classModel: classModel, userModel: userModel),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
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
        title: Text(userModel.name),
        leading: IconButton(
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              )),
          icon: const Icon(Icons.logout),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: classListProvider.classList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () => navigateToMarkAttendance(
                        classModel: classListProvider.classList[index]),
                    title: Text(classListProvider.classList[index].name),
                    leading: const Icon(
                      Icons.class_rounded,
                      color: Palette.primary500,
                      size: 50,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
