// ignore_for_file: unused_local_variable, null_check_always_fails

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project/blocs/auth_bloc.dart';
import 'package:project/screens/login.dart';
import 'package:provider/provider.dart';

import 'screens/Categories/chooseCate.dart';

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
