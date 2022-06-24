// ignore_for_file: unnecessary_import, avoid_types_as_parameter_names, non_constant_identifier_names

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:project/blocs/auth_bloc.dart';
import 'package:project/Background/bg_profile.dart';
import 'package:project/screens/login.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamSubscription<User> loginStateSubscription;

  @override
  void initState() {
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    authBloc.currentUser.listen((User) async {
      if (User == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    });
    super.initState();
  }

  // @override
  // void dispose() {
  //   loginStateSubscription.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 254, 253),
      appBar: AppBar(
        // backgroundColor: Color.fromARGB(255, 24, 80, 163),
         backgroundColor: const Color.fromARGB(255, 13, 104, 96),
        title: const Text('My Profile'),
      ),
      body: Center(
        child: Container(
          height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      //"https://images.pexels.com/photos/7135115/pexels-photo-7135115.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
                      "https://i.pinimg.com/originals/92/c6/f1/92c6f1f583f498c74ef5bb0a5b128d8e.jpg"),
                  fit: BoxFit.cover),
            ),
          child: Center(
            child: StreamBuilder<User?>(
                stream: authBloc.currentUser,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();

                  return Column(
                    children: [
                      const SizedBox(
                        height: 80,
                      ),
                      CircleAvatar(
                        maxRadius: 70,
                        backgroundImage:
                            NetworkImage(snapshot.data?.photoURL ?? ""),
                      ),
                      const SizedBox(
                        height:80,
                      ),
                      const Text("Profile",
                          style: TextStyle(fontSize: 35.0, color: Colors.white)),
                      const SizedBox(
                        height: 50.0,
                      ),
                      Text(snapshot.data?.displayName ?? "",
                          style: const TextStyle(
                              fontSize: 25, color: Colors.white)),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text(snapshot.data?.email ?? "",
                          style: const TextStyle(
                              fontSize: 25, color: Colors.white)),
                      const SizedBox(
                        height: 50.0,
                      ),
                      SignInButton(Buttons.Google,
                          text: 'Sign Out of Google',
                          onPressed: () => authBloc.logout())
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
