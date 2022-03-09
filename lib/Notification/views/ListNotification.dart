// ignore_for_file: prefer_const_constructors_in_immutables, file_names

import 'package:flutter/material.dart';

class ListNotification extends StatefulWidget {
  ListNotification({Key? key}) : super(key: key);

  @override
  State<ListNotification> createState() => _ListNotificationState();
  
}

class _ListNotificationState extends State<ListNotification> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: ListView(
            children: 
                 const [
                  Text('Image Notification'),
                  Text("data"),
              ],
    )
    );
  }
}