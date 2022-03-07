// ignore_for_file: file_names
// // ignore_for_file: file_names, camel_case_types, avoid_print

// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // import 'dart:io';
// // import 'package:http/http.dart' as http;

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();


// class noti extends StatefulWidget {
//   const noti({Key? key}) : super(key: key);

 
//   @override
//   State<noti> createState() => _notiState();
// }

// class _notiState extends State<noti> {

// //   //  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// //   late String message;
// //   String channelId = "1000";
// //   String channelName = "FLUTTER_NOTIFICATION_CHANNEL";
// //   String channelDescription = "FLUTTER_NOTIFICATION_CHANNEL_DETAIL";

  

  
// //  @override
// //   initState() {
// //     message = "No message.";

// //     var initializationSettingsAndroid =
// //         const AndroidInitializationSettings('ic_launcher');

// //     var initializationSettingsIOS = IOSInitializationSettings(
// //         onDidReceiveLocalNotification: (id, title, body, payload) {
// //       print("onDidReceiveLocalNotification called.");
// //     });
// //     var initializationSettings = InitializationSettings(
// //         android: initializationSettingsAndroid,iOS: initializationSettingsIOS);

// //     flutterLocalNotificationsPlugin.initialize(initializationSettings,
// //         onSelectNotification: (payload) {
// //       // when user tap on notification.
// //       print("onSelectNotification called.");
// //       setState(() {
// //         message = payload!;
// //       });
// //     });
// //     super.initState();
// //   }

// //  sendNotification() async {
// //     var androidPlatformChannelSpecifics = const AndroidNotificationDetails('10000',
// //         'FLUTTER_NOTIFICATION_CHANNEL' 'FLUTTER_NOTIFICATION_CHANNEL_DETAIL',
// //         importance: Importance.max, priority: Priority.high);
// //     var iOSPlatformChannelSpecifics = const IOSNotificationDetails();

// //     var platformChannelSpecifics = NotificationDetails(
// //         android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

// //     await flutterLocalNotificationsPlugin.show(1000, 'Hello, benznest.',
// //         'This is a your notifications. ', platformChannelSpecifics,
// //         payload: 'I just haven\'t Met You Yet');
// //   }

//   @override
//   Widget build(BuildContext context) {
//      return Scaffold(
//       appBar: AppBar(
//         title: const Text("noti"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'message',
//               style: const TextStyle(fontSize: 24),
//             ),
//           ],
//         ),
//       ),
      
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // sendNotification();
//           notifications.showNotification(
//             title: 'Sarah Abs',
//             body:'Hey! Do we have ev',
//             payload: 'sarah.abs',
//           );
    
//         },
//         tooltip: 'Increment',
//         child: const Icon(Icons.send),
//       ),
//     );
//   }
// }

// class notifications {
//   static final _notifications = FlutterLocalNotificationsPlugin();
//   static Future showNotification({
//     int id = 0,
//     String? title,
//     String? body,
//     String? payload,
//   }) async =>
//       _notifications.show(
//         id,
//         title,
//         body,
//         await _notificationDetails(),
//         payload: payload,
//       );

//   static Future _notificationDetails() async {
//     return const NotificationDetails(
//       android: AndroidNotificationDetails(
//         'channel id',
//         'channel name',
//         importance: Importance.max,
//       ), // AndroidNotificationDetails
//     );
//   }
// }