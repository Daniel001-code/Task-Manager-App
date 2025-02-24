import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_app/model/task_model.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotiService {
  final notificationPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  //initialize
  Future<void> initNotification() async {
    // Initialize time zones
    tz.initializeTimeZones();

    if (_isInitialized) return;

    // Android initialization settings
    const AndroidInitializationSettings initSettingAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const DarwinInitializationSettings initSettingIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSetting = InitializationSettings(
      android: initSettingAndroid,
      iOS: initSettingIOS,
    );

    // Initialize the plugin
    await notificationPlugin.initialize(initSetting);

    // Ensure Android Notification Channel is created
    await notificationPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            'task_channel', // Same ID as in notificationDetails()
            'Task Notifications',
            description: 'Reminder notifications for tasks',
            importance: Importance.max,
          ),
        );

    _isInitialized = true;
  }

  // notification detail

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'task_channel',
        'Task Notifications',
        channelDescription: 'Reminder notifications for tasks',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  // show notification

  Future<void> showNotification(Task task) async {
    // Schedule notification 10 seconds after task creation
    final tz.TZDateTime scheduledTime =
        tz.TZDateTime.now(tz.local).add(const Duration(minutes: 5));
    debugPrint('Notification scheduled for: $scheduledTime');
    return Future.delayed(const Duration(minutes: 5), () {
      notificationPlugin
          // .zonedSchedule(
          //     task.id!,
          //     'Task Reminder',
          //     'Reminder for task: ${task.title}',
          //     scheduledTime,
          //     notificationDetails(),
          //     uiLocalNotificationDateInterpretation:
          //         UILocalNotificationDateInterpretation.absoluteTime,
          //     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
          .show(
        task.id!,
        'Task Reminder',
        'Reminder for task: ${task.title}',
        notificationDetails(),
      );
    });
  }

  // on notification click
}
