// ignore_for_file: unused_import, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:project/blocs/auth_bloc.dart';
import 'package:project/screens/Categories/AddCategories.dart';
import 'package:project/screens/Myevents.dart';
import 'package:project/screens/bg_menu.dart';
import 'package:project/screens/home.dart';
import 'package:provider/provider.dart';

import 'postcategorise.dart';
//import 'package:flutter_application_1/screen/createeventspost.dart';

//import 'package:flutter_application_1/screen/homepage.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 30, 150, 140),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 30, 150, 140),
        title: const Text(
          "Menu",
          style: TextStyle(
            fontSize: 25,
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Background(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.white)),
                    child: Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const[
                         Icon(Icons.add),
                         Text(
                          "Create Category",
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'RobotoMono',
                              color: Colors.black),
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const addcate();
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
                            Colors.white)),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Icon(Icons.add),
                         Text(
                          "Create Event",
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'RobotoMono',
                              color: Colors.black),
                        ),
                      ],
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
                            Colors.white)),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const[
                        Icon(Icons.event_available_outlined),
                         Text(
                          "My Events",
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'RobotoMono',
                              color: Colors.black),
                        ),
                      ],
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
                            Colors.white)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const[
                        Icon(Icons.account_box),
                         Text(
                          "My Profile",
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'RobotoMono',
                              color: Colors.black),
                        ),
                      ],
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
      ),
    );
  }
}
