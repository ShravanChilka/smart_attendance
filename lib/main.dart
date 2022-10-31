import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_attendance/providers/attendance_status.dart';
import 'package:smart_attendance/providers/class_list_provider.dart';
import 'package:smart_attendance/providers/loading_provider.dart';
import 'package:smart_attendance/providers/user_list_provider.dart';
import 'package:smart_attendance/screens/login_screen.dart';
import 'services/database/g_sheet_api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GSheetApiService().init();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => ClassListProvider()),
      ChangeNotifierProvider(create: (context) => UserListProvider()),
      ChangeNotifierProvider(create: (context) => AttendanceStatusProvider()),
      ChangeNotifierProvider(create: (context) => LoadingProvider()),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.orange,
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.orangeAccent)),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
        backgroundColor: Colors.orangeAccent,
        animationDuration: const Duration(seconds: 1),
        nextScreen: LoginScreen(),
        splash: const Center(
          child: Text(
            "Smart Attendance",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 34,
            ),
          ),
        ),
      ),
    );
  }
}