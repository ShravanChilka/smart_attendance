import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_attendance/providers/providers_export.dart';
import 'package:smart_attendance/screens/screens_export.dart';
import 'package:smart_attendance/services/database/models/model_export.dart';
import 'package:smart_attendance/widgets/widgets.dart';

import '../widgets/styles.dart';

class LoginScreenOld extends StatelessWidget {
  LoginScreenOld({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final classListProvider = Provider.of<ClassListProvider>(context);
    final loadingProvider = Provider.of<LoadingProvider>(context);

    void showSnackBar({required String message}) {
      var snackBar = SnackBar(
        content: Text(
          message,
        ),
        backgroundColor: Palette.primary500,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    void navigateUser({required UserModel userModel}) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserScreen(userModel: userModel),
        ),
      );
    }

    void navigateAdmin() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdminScreen(),
        ),
      );
    }

    void loginClickEvent(
        {required String email, required String password}) async {
      loadingProvider.isLoading = true;
      final userList = await UserHelper().getAll();

      bool isValid = false;
      if (email == "admin" && password == "admin") {
        classListProvider.classList = await ClassModelHelper().getAll();
        loadingProvider.isLoading = false;
        navigateAdmin();
        isValid = true;
      } else {
        for (UserModel userModel in userList) {
          if (userModel.email == email && userModel.password == password) {
            classListProvider.classList = await ClassModelHelper().getAll();
            loadingProvider.isLoading = false;
            navigateUser(userModel: userModel);
            isValid = true;
            break;
          }
        }
      }
      if (!isValid) {
        loadingProvider.isLoading = false;
        debugPrint("INVALID");
        showSnackBar(message: "Invalid credentials");
      }
    }

    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          leading: loadingProvider.isLoading
              ? const Center(
                  child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator()),
                )
              : const Icon(Icons.change_history),
          title: const Text("Welcome"),
        ),
        body: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "SMART",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                  color: Palette.primary500,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                ),
                              ),
                              AnimatedContainer(
                                margin: const EdgeInsets.only(left: 20),
                                height: 2,
                                width: 50,
                                color: Palette.primary500,
                                duration: const Duration(milliseconds: 800),
                                curve: Curves.fastOutSlowIn,
                              )
                            ],
                          ),
                          const CustomAnimatedText(),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                          title: "Email",
                          hintText: "Enter your email",
                          textController: _emailController),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        title: "Password",
                        hintText: "Enter your password",
                        textController: _passwordController,
                        isPassword: true,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () => loginClickEvent(
                          email: _emailController.text.toString(),
                          password: _passwordController.text.toString(),
                        ),
                        child: SizedBox(
                          width: size.width,
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 8, bottom: 8),
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                        ),
                      ),
                    ],
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
