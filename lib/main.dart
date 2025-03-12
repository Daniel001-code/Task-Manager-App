import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notification_app/controller/task_controller.dart';
import 'package:notification_app/services/notification_service.dart';
import 'package:notification_app/ui/home_page.dart';
import 'package:notification_app/ui/splash_screen.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  requestNotificationPermission();

  // initialize notification

  NotiService().initNotification();
  runApp(const MyApp());

  Get.put(TaskController());
}

Future<void> requestNotificationPermission() async {
  var status = await Permission.notification.status;
  if (!status.isGranted) {
    await Permission.notification.request();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/slash-screen',
      routes: {
        '/': (context) => const HomePage(),
        '/slash-screen': (context) => const SplashScreen(),
      },
    );
  }
}
