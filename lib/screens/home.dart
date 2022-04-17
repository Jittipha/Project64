// ignore_for_file: unnecessary_import

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:project/blocs/auth_bloc.dart';
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
    authBloc.currentUser.listen((project) async {
      if (project == null) {
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
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: Center(
        child: StreamBuilder<User?>(
            stream: authBloc.currentUser,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const CircularProgressIndicator();

              return Column(
                children: [
                  const SizedBox(height: 70),
                  const Text('Student',
                      style: TextStyle(
                        fontSize: 30.0,
                      )),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(snapshot.data?.displayName ?? "",
                      style: const TextStyle(fontSize: 20.0)),
                  Text(snapshot.data?.email ?? "",
                      style: const TextStyle(fontSize: 20.0)),
                  const SizedBox(
                    height: 50.0,
                  ),
                  CircleAvatar(
                    maxRadius: 70,
                    backgroundImage:
                        NetworkImage(snapshot.data?.photoURL ?? ""),
                  ),
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
    );
  }
}
