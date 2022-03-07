// ignore_for_file: unused_import, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:project/blocs/auth_bloc.dart';
import 'package:project/screens/Myevents.dart';
import 'package:project/screens/home.dart';
import 'package:provider/provider.dart';

import 'addcategorise.dart';
import 'postcategorise.dart';
//import 'package:flutter_application_1/screen/createeventspost.dart';

//import 'package:flutter_application_1/screen/homepage.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MENU",
          style: TextStyle(
            fontSize: 25,
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            SizedBox(
              height: 60,
              width: double.infinity,
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.green.shade200)),
                  child: const Text(
                    "Create Categories",
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'RobotoMono',
                        color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const AddCategorise();
                    }));
                  }),
            ),
            const SizedBox(
              height: 20,
              width: double.infinity,
            ),
            SizedBox(
              height: 60,
              width: double.infinity,
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.green.shade200)),
                  child: const Text(
                    "Create Event",
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'RobotoMono',
                        color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Post();
                    }));
                  }),
            ),
            const SizedBox(
              height: 20,
              width: double.infinity,
            ),
            SizedBox(
              height: 60,
              width: double.infinity,
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.green.shade200)),
                  child: const Text(
                    "My Events",
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'RobotoMono',
                        color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const MyEvent();
                    }));
                  }),
            ),
            const SizedBox(
              height: 20,
              width: double.infinity,
            ),
            SizedBox(
              height: 60,
              width: double.infinity,
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.yellow.shade200)),
                  child: const Text(
                    "My Profile",
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'RobotoMono',
                        color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const HomeScreen();
                    }));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
