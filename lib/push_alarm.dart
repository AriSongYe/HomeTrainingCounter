// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_core/core.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// Future<void> pushAlarm() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await initializeNotifications();
//   runApp(const ThirdRoute());
// }

// Future<void> initializeNotifications() async {
//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('app_icon');
//   const InitializationSettings initializationSettings =
//       InitializationSettings(android: initializationSettingsAndroid);
//   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
// }

// Future<void> scheduleDailyNotification(TimeOfDay notificationTime) async {
//   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails(
//     '0',
//     '운동할 시간입니다.',
//     importance: Importance.max,
//     priority: Priority.high,
//   );
//   const NotificationDetails platformChannelSpecifics =
//       NotificationDetails(android: androidPlatformChannelSpecifics);

//   final now = DateTime.now();
//   final scheduledTime = DateTime(
//     now.year,
//     now.month,
//     now.day,
//     notificationTime.hour,
//     notificationTime.minute,
//   );

//   if (scheduledTime.isBefore(now)) {
//     // 이미 지난 시간인 경우, 다음 날로 예약
//     scheduledTime.add(const Duration(days: 1));
//   }

//   await flutterLocalNotificationsPlugin.zonedSchedule(
//     0, // 알림 ID
//     '매일 알림', // 알림 제목
//     '매일 알림 내용', // 알림 내용
//     tz.TZDateTime.from(scheduledTime, tz.local), // 예약 시간
//     const DailyTime = DailyTimeIntervalSchedule(
//       startTime: Time(notificationTime.hour, notificationTime.minute),
//       endTime: Time(notificationTime.hour, notificationTime.minute),
//       repeatInterval: RepeatInterval.daily,
//     ),
//     platformChannelSpecifics,
//     uiLocalNotificationDateInterpretation:
//         UILocalNotificationDateInterpretation.absoluteTime,
//   );
// }

// class ThirdRoute extends StatelessWidget {
//   const ThirdRoute({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: const Text('매일 알림 설정')),
//         body: Center(
//           child: ElevatedButton(
//             onPressed: () => showTimePickerDialog(context),
//             child: const Text('알림 시간 선택'),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> showTimePickerDialog(BuildContext context) async {
//     final TimeOfDay? selectedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (selectedTime != null) {
//       await scheduleDailyNotification(selectedTime);
//     }
//   }
// }
