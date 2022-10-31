import 'package:flutter/material.dart';
import 'package:smart_attendance/screens/screens_export.dart';
import 'package:smart_attendance/services/database/models/class.dart';
import 'package:provider/provider.dart';
import 'package:smart_attendance/widgets/widgets.dart';
import '../providers/providers_export.dart';
import '../services/database/models/attendance.dart';

class AdminScreen extends StatelessWidget {
  AdminScreen({Key? key}) : super(key: key);
  final TextEditingController _classNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final attendanceStatusProvider =
        Provider.of<AttendanceStatusProvider>(context);
    final classListProvider = Provider.of<ClassListProvider>(context);
    final loadingProvider = Provider.of<LoadingProvider>(context);
    final userListProvider = Provider.of<UserListProvider>(context);

    navigateToStartAttendance({required ClassModel classModel}) async {
      loadingProvider.isLoading = true;
      attendanceStatusProvider.classModel = classModel;
      userListProvider.userList = await AttendanceHelper()
          .getUserByClassId(classId: classModel.id)
          .whenComplete(() {
        loadingProvider.isLoading = false;
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  StartAttendanceScreen(classModel: classModel),
            ));
      });
    }

    Future<void> createNewClassEvent(String className) async {
      loadingProvider.isLoading = true;
      await ClassModelHelper().create(classModel: ClassModel(name: className));
      classListProvider.classList = await ClassModelHelper().getAll();
      loadingProvider.isLoading = false;
    }

    void createUserClickEvent() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateUserScreen()));
    }

    Future<void> addClassClickEvent() async {
      await showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CustomTextField(
                  title: "Class Name",
                  hintText: "Enter class name",
                  textController: _classNameController,
                ),
                const Spacer(),
                SafeArea(
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: FloatingActionButton(
                      onPressed: () async {
                        await createNewClassEvent(_classNameController.text)
                            .whenComplete(() => Navigator.of(context).pop());
                      },
                      child: const Icon(Icons.check),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btnCreateUser",
            onPressed: () => createUserClickEvent(),
            child: const Icon(Icons.person_add),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            heroTag: "btnCreateClass",
            onPressed: () => addClassClickEvent(),
            child: const Icon(Icons.add),
          ),
        ],
      ),
      appBar: AppBar(
        title: const Text("Admin"),
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
        leading: IconButton(
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
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
                    onTap: () => navigateToStartAttendance(
                        classModel: classListProvider.classList[index]),
                    title: Text(classListProvider.classList[index].name),
                    leading: const Icon(
                      Icons.class_rounded,
                      color: Colors.orangeAccent,
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
