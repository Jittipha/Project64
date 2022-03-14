// ignore_for_file: unused_local_variable, null_check_always_fails

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:project/Notification/services/notification.dart';
// import 'package:project/Notification/views/home_view.dart';
import 'package:project/blocs/auth_bloc.dart';
import 'package:project/screens/Home_Feed/today.dart';
import 'package:project/screens/login.dart';
// import 'package:project/screens/editeventpost.dart';
// import 'package:project/screens/login.dart';
// import 'package:project/blocs/auth_bloc.dart';
// import 'package:project/screens/login.dart';
// import 'package:project/blocs/auth_bloc.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => AuthBloc(),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.grey,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//         child: MaterialApp(
//           theme: ThemeData(fontFamily: 'Monteserat'),
//           home: const HomePage(),
//           debugShowCheckedModeBanner: false,
//         ),
//         providers: [
//           ChangeNotifierProvider(create: (_) => NotificationService())
//         ]);
//   }
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Provider(
//       create: (context) => AuthBloc(),
//       create: (context) => NotificationService(),

//       child: MaterialApp(
//         theme: ThemeData(
//           primarySwatch: Colors.grey,
//           visualDensity: VisualDensity.adaptivePlatformDensity,
//         ),
//         home: HomePage(),

//       ),

//     );
//   }
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//         child: MaterialApp(
//           theme: ThemeData(fontFamily: 'Monteserat'),
//           home: HomePage(),
//           debugShowCheckedModeBanner: false,
//         ),
//         providers: [
//           ChangeNotifierProvider(create: (_) => NotificationService(),AuthBloc()),
//           ChangeNotifierProvider(create: (_) => AuthBloc()),
//         ]);
//   }
// }