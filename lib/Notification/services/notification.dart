// ignore_for_file: unnecessary_new, unnecessary_const, unused_local_variable, unused_label, null_check_always_fails, avoid_print, non_constant_identifier_names


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:project/Notification/views/home_view.dart';
// import 'package:snapshot/snapshot.dart';
import 'package:project/Model/Event.dart';


class NotificationService extends ChangeNotifier {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  events event = events();
  // initilize

  Future initialize() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
         
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings("ic_launcher");

    IOSInitializationSettings iosInitializationSettings =
        const IOSInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: androidInitializationSettings,
            iOS: iosInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  //Instant Notifications
  // Future instantNofitication() async {
  //   var android = const AndroidNotificationDetails("id","channel");

  //   var ios = const IOSNotificationDetails();

  //   var platform = new NotificationDetails(android: android, iOS: ios);

  //   await _flutterLocalNotificationsPlugin.show(
  //       0, "ผผผ", "อีเว้นนี้มีการเปลี่ยนแปลง", platform,
  //       payload: "Welcome to demo app");
  // }

  //Image notification
  Future imageNotification(event) async {
    
    
    var bigPicture = const BigPictureStyleInformation(
        const DrawableResourceAndroidBitmap("ic_launcher"),
        largeIcon:const DrawableResourceAndroidBitmap("ic_launcher"),
    
        // contentTitle:"valo",
        // summaryText: "อีเว้นนี้มีการเปลี่ยนแปลง",
        htmlFormatContent: true,
        htmlFormatContentTitle: true);

    var android = AndroidNotificationDetails("id", "channel",
        styleInformation: bigPicture);

    var platform = new NotificationDetails(
      android: android,
    );

    await _flutterLocalNotificationsPlugin.show(
      0, (event.Name), "This event has changed.", platform,
      //payload: ("Welcome to demo app")
    );
    print(event.Name);
  }
}
