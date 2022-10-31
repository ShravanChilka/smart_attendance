import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_attendance/services/database/models/model_export.dart';
import 'package:smart_attendance/widgets/custom_text_field.dart';

import '../providers/loading_provider.dart';

class CreateUserScreen extends StatelessWidget {
  CreateUserScreen({Key? key}) : super(key: key);

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loadingProvider = Provider.of<LoadingProvider>(context);

    Future<void> createUserClickEvent({
      required String name,
      required String email,
      required String password,
    }) async {
      loadingProvider.isLoading = true;
      await UserHelper()
          .create(
              userModel:
                  UserModel(name: name, email: email, password: password))
          .then((result) {
        if (result != null) {
          result ? Navigator.pop(context) : debugPrint("failed to create user");
        }
      });
      loadingProvider.isLoading = false;
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => createUserClickEvent(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        ),
        child: const Icon(Icons.check),
      ),
      appBar: AppBar(
        title: const Text("Create New User"),
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
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomTextField(
              title: "Full Name",
              hintText: "Enter full name",
              textController: _nameController,
            ),
            CustomTextField(
              title: "Email ID",
              hintText: "Enter email id",
              textController: _emailController,
            ),
            CustomTextField(
              title: "Password",
              hintText: "Enter password",
              textController: _passwordController,
            )
          ],
        ),
      ),
    );
  }
}
