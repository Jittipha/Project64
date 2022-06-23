
// ignore_for_file: file_names

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/Model/Event.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // createPlantFoodNotification();
              },
              child: const Text("Local Notification"),
            ),
          ],
        ),
      ),
    );
  }
}

final FirebaseFirestore fireStore = FirebaseFirestore.instance;

events event = events();


Future createPlantFoodNotification(event) async {

 await AwesomeNotifications().initialize(
      // 'android/app/src/mainres/drawable/ic_launcher.png',
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupkey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);

    

 await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 2,
          channelKey: 'basic_channel',
          title: event.Name,
          body:'This event has changed.',
          bigPicture:(event.Image),
          notificationLayout: NotificationLayout.BigPicture
        ));
        
         
}
