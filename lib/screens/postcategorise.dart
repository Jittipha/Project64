import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:project/Model/Event.dart';
import 'package:project/screens/Myevents.dart';
import 'package:project/screens/addcategorise.dart';
import 'package:project/screens/tabbar.dart';
import 'package:project/Model/Student.dart';
import 'editeventpost.dart';
//import 'package:flutter_application_1/screen/addcategorise.dart';
//import 'package:flutter_application_1/screen/createeventspost.dart';
//import 'package:flutter_application_1/screen/homepage.dart';

// ignore: use_key_in_widget_constructors
class Post extends StatefulWidget {
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  final _formKey = GlobalKey<FormState>();
  Students student = Students();
  events event = events();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Post",
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.photo_size_select_small_outlined),
                    hintText: 'Link Photo',
                  ),
                  validator: RequiredValidator(errorText: "กรุณาใส่รูป!"),
                  onSaved: (value) {
                    event.Image = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.account_circle_sharp),
                    hintText: 'Name',
                  ),
                  validator: RequiredValidator(errorText: "กรุณาใส่ชื่อ!"),
                  onSaved: (value) {
                    event.Name = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      icon: Icon(Icons.message_outlined),
                      hintText: 'Description'),
                  validator: RequiredValidator(errorText: "กรุณาใส่คำอธิบาย!"),
                  onSaved: (value) {
                    event.Description = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      icon: Icon(Icons.where_to_vote_sharp),
                      hintText: 'Location'),
                  validator: RequiredValidator(errorText: "กรุณาใส่ที่อยู่!"),
                  onSaved: (value) {
                    event.Location = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      icon: Icon(Icons.menu_book_outlined),
                      hintText: 'interests'),
                  validator: RequiredValidator(errorText: "กรุณาใส่หมวดหมู่!"),
                  onSaved: (value) {
                    event.interests = value;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.orangeAccent),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1),
                              side: const BorderSide(color: Colors.green),
                            ))),
                        child: const Text("Continue",
                            style: TextStyle(fontSize: 20, color: Colors.black),
                            textAlign: TextAlign.center),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            await FirebaseFirestore.instance
                                .collection('Event')
                                .doc()
                                .set({
                              "Image": event.Image,
                              "Name": event.Name,
                              "Description": event.Description,
                              "Time": event.Time,
                              "Location": event.Location,
                              "interests": event.interests,
                              // "Host": [{"Student_id" : ,"Name" : ,"Photo":}]
                            });
                            // await FirebaseFirestore.instance
                            //       .collection('Event')
                            //       .where('Name =='+ event.Name!)
                            //       .get()
                            //       .then((DocumentSnapshot snapshot) async{
                            //         if(snapshot.exists){
                            //           print("w")
                            //         }
                            //       });
                            QuerySnapshot snap = await FirebaseFirestore
                                .instance
                                .collection('Event')
                                .where("Name", isEqualTo: event.Name)
                                .where("Description",
                                    isEqualTo: event.Description)
                                .get();
                            snap.docs.forEach((document) async {
                              await FirebaseFirestore.instance
                                  .collection('Student')
                                  .doc(FirebaseAuth.instance.currentUser?.uid)
                                  .collection('Posts')
                                  .doc()
                                  .set({
                                "Image": event.Image,
                                "Name": event.Name,
                                "Description": event.Description,
                                "Time": event.Time,
                                "Location": event.Location,
                                "Event_id": document.id,
                                "interests": event.interests,
                              }).then((value) => {
                                        Fluttertoast.showToast(
                                            msg: "Success!",
                                            gravity: ToastGravity.CENTER),
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return const Tabbar();
                                          },
                                        ))
                                      });
                            });
                          }
                        }),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
