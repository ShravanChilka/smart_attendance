import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_attendance/screens/user_screen.dart';
import 'package:smart_attendance/widgets/styles.dart';
import 'package:smart_attendance/widgets/widgets.dart';

import '../providers/class_list_provider.dart';
import '../providers/loading_provider.dart';
import '../services/database/models/class.dart';
import '../services/database/models/user.dart';
import 'admin_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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

    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/bg_image.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.all(defaultPadding),
              padding: const EdgeInsets.all(defaultPadding * 2),
              decoration: BoxDecoration(
                color: Palette.neutral300,
                borderRadius: BorderRadius.circular(defaultRadius * 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: defaultPadding * 4),
                  Text(
                    'Login',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: defaultPadding * 4),
                  CustomTextField(
                    title: 'Email',
                    hintText: 'Enter email',
                    textController: _emailController,
                    prefixIcon: const Icon(Icons.person),
                  ),
                  CustomTextField(
                    title: 'Password',
                    hintText: 'Enter password',
                    isPassword: true,
                    textController: _passwordController,
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  const SizedBox(height: defaultPadding * 4),
                  ElevatedButton(
                    onPressed: () => loginClickEvent(
                      email: _emailController.text.toString(),
                      password: _passwordController.text.toString(),
                    ),
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: defaultPadding * 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
