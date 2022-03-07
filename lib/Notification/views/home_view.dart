// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:project/Notification/services/notification.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // Provider.of<NotificationService>(context, listen: false).initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
            children: 
                const [
                  Text('Image Notification'),
                  Text("data"),
                
              ],
                

                
                //child: Consumer<NotificationService>(
     
      
        // ElevatedButton(
        //     onPressed: () => model.instantNofitication(),
        //     child: const Text('Instant Notification')),
        // ElevatedButton(
            // onPressed: () => model.imageNotification(),
            // child: Text('Image Notification')),
        // ElevatedButton(
        //     onPressed: () => model.stylishNotification(),
        //     child: const Text('Media Notification')),
        // ElevatedButton(
        //     onPressed: () => model.sheduledNotification(),
        //     child: const Text('Scheduled Notification')),
        // ElevatedButton(
        //     onPressed: () => model.cancelNotification(),
        //     child: const Text('Cancel Notification')),
      // ]),
    // )
    // )
    )
    );
  }
}