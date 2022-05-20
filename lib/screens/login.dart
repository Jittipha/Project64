// ignore_for_file: unused_import

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:project/blocs/auth_bloc.dart';
import 'package:project/Background/bg.dart';
import 'package:project/screens/home.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late StreamSubscription<User> loginStateSubscription;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);

    return Background(
      child: Column(
        children: [
          const SizedBox(
            height: 90,
          ),
          Image.asset(
              "assets/images/logo_nnn.png",
              width: 500,
              
             ),
          const SizedBox(
            height: 20,
          ),
          //   Image.network(
          //   'https://firebasestorage.googleapis.com/v0/b/my-project-application-7b7c7.appspot.com/o/logo%2FLogodpu.png?alt=media&token=8ea67ca6-b828-42b0-9d59-ecc48b22fef9',
          //   width: 500,
          //   height: 70,
          // ),
          SignInButton(
            Buttons.Google,
            text: 'Sign in with Google',
            onPressed: () async => await authBloc.loginGoogle(context),
          ),
        ],
      ),
    );
  }
}
