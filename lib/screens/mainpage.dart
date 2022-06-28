// ignore_for_file: unused_import, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:project/blocs/auth_bloc.dart';
import 'package:project/screens/Categories/AddCategories.dart';
import 'package:project/screens/Categories/editCate.dart';
import 'package:project/screens/Myevents.dart';
import 'package:project/Background/bg_menu.dart';
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
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 48, 180, 169),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 30, 150, 140),
        // title: const Text(
        // title: const Text(
        //   "Menu",
        //   style: TextStyle(
        //     fontSize: 25,
        //     letterSpacing: 0.5,
        //     fontFamily: 'Raleway',
        //     fontWeight: FontWeight.w600,
        //   ),
        // ),
      ),
      body: Container(
        // height: double.infinity,
        //     width: double.infinity,
        //     decoration: const BoxDecoration(
        //       image: DecorationImage(
        //           image: NetworkImage(
        //               //"https://images.pexels.com/photos/7135115/pexels-photo-7135115.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
        //               //"https://images.pexels.com/photos/12117995/pexels-photo-12117995.jpeg"
        //               "https://i.pinimg.com/474x/e4/ca/09/e4ca09b0c87e560f1df62c578d3af42e--iphone--wallpaper-phone-backgrounds.jpg"),
        //           fit: BoxFit.cover),
        //     ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.yellow.shade200)),
                    child: Wrap(
                      children: const <Widget>[
                        Icon(
                          Icons.control_point_outlined,
                          color: Color.fromARGB(255, 9, 9, 9),
                          size: 30,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 200,
                          child: Text(
                            "Edit your Categories",
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'RobotoMono',
                                color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const editcate();
                      }));
                    }),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.yellow.shade200)),
                    child: Wrap(
                      children: const <Widget>[
                        Icon(
                          Icons.control_point_outlined,
                          color: Color.fromARGB(255, 9, 9, 9),
                          size: 30,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 200,
                          child: Text(
                            "Create Category",
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'RobotoMono',
                                color: Colors.black),
                          ),
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
                            Colors.yellow.shade200)),
                    child: Wrap(
                      children: const <Widget>[
                        Icon(
                          Icons.control_point_outlined,
                          color: Color.fromARGB(255, 9, 9, 9),
                          size: 30,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 200,
                          child: Text(
                            "Create Event",
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'RobotoMono',
                                color: Colors.black),
                          ),
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
                            Colors.yellow.shade200)),
                    child: Wrap(
                      children: const <Widget>[
                        Icon(
                          Icons.event_available_outlined,
                          color: Color.fromARGB(255, 9, 9, 9),
                          size: 30,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 200,
                          child: Text(
                            "My Events",
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'RobotoMono',
                                color: Colors.black),
                          ),
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
                            Colors.yellow.shade200)),
                    child: Wrap(
                      children: const <Widget>[
                        Icon(
                          Icons.account_box_rounded,
                          color: Color.fromARGB(255, 9, 9, 9),
                          size: 30,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 200,
                          child: Text(
                            "My Profile",
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'RobotoMono',
                                color: Colors.black),
                          ),
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
