// ignore_for_file: avoid_print, duplicate_ignore, prefer_collection_literals, non_constant_identifier_names, unused_element, unused_field, unused_local_variable, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project/screens/home.dart';
import 'package:project/services/auth_service.dart';
import 'package:project/chooseCate.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/tabbar.dart';
import 'package:project/Model/Student.dart';
import 'package:project/main.dart';

class AuthBloc {
  final authService = AuthService();
  final googleSignIn = GoogleSignIn(scopes: ['email']);
  // CollectionReference insertValue =
  //     FirebaseFirestore.instance.collection('Student');
  Students students = Students();
  Stream<User?> get currentUser => authService.currentUser;

  loginGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

      //Firebase Sign in
      var result = await authService.signInWithCredential(credential);
      students.Name = result.user?.displayName;
      students.uid = result.user?.uid;
      students.Photo = result.user?.photoURL;

      ;
      // ignore: avoid_print
      print('${result.user?.displayName}');

      await FirebaseFirestore.instance
          .collection('Student')
          .doc(result.user?.uid)
          .get()
          .then((DocumentSnapshot snapshot) async {
        if (snapshot.exists) {
          await FirebaseFirestore.instance
              .collection('Student')
              .doc(result.user?.uid)
              .update({
            "Email": result.user?.email,
            "Name": result.user?.displayName,
            "Photo": result.user?.photoURL
          }).then((value) => {
                    Fluttertoast.showToast(
                        msg: "เข้าสู่ระบบสำเร็จ!",
                        gravity: ToastGravity.CENTER),
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const Tabbar()),
                    ),
                  });
        } else {
          await FirebaseFirestore.instance
              .collection('Student')
              .doc(result.user?.uid)
              .set({
            "Email": result.user?.email,
            "Name": result.user?.displayName,
            "Photo": result.user?.photoURL
          }).then((value) => {
                    Fluttertoast.showToast(
                        msg: "เข้าสู่ระบบสำเร็จ!",
                        gravity: ToastGravity.CENTER),
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const Tabbar()),
                    ),
                  });
        }
      });

      // FirebaseFirestore.instance.collection('Student').doc().set({
      //   "Email": result.user?.email,
      //   "Name": result.user?.displayName,
      //   "Photo": result.user?.photoURL
      // });
    } catch (error) {
      // ignore: avoid_print
      print(error);
    }
  }

  logout() async {
    await authService.logout();
    await googleSignIn.signOut();
  }
}
