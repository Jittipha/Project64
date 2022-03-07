// ignore_for_file: unused_import, must_be_immutable, avoid_unnecessary_containers, override_on_non_overriding_member, avoid_print, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:project/Model/Event.dart';
import 'package:project/Notification/services/notification.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'Interests.dart';
import 'Myevents.dart';
import 'homepage.dart';

class EditEvent extends StatefulWidget {
  EditEvent({
    Key? key,
    required this.studenthasposts,
  }) : super(key: key);
  // final QueryDocumentSnapshot<Object?> studenthasposts;
  QueryDocumentSnapshot<Object?> studenthasposts;

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  events event = events();
  bool isLoading = false;

  var model = NotificationService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: fireStore
            .collection('Student')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('Posts')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const SingleChildScrollView(
              child: CircularProgressIndicator(),
            );
          }
          return Scaffold(
              appBar: AppBar(
                title: const Text(
                  "Event",
                  style: TextStyle(fontSize: 25, color: Colors.black),
                ),
              ),
              body: SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: Form(
                      key: _formKey,
                      child: Column(children: <Widget>[
                        Container(
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                                '${widget.studenthasposts["Image"]}'),
                          ),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            icon: const Icon(
                                Icons.photo_size_select_small_outlined),
                            hintText: widget.studenthasposts["Image"],
                          ),
                          initialValue: widget.studenthasposts["Image"],
                          validator:
                              RequiredValidator(errorText: "กรุณาใส่ลิงก์รูป!"),
                          onSaved: (value) {
                            setState(() => event.Image = value);
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            icon: const Icon(Icons.account_circle_sharp),
                            hintText: widget.studenthasposts["Name"],
                          ),
                          initialValue: widget.studenthasposts["Name"],
                          validator:
                              RequiredValidator(errorText: "กรุณาใส่ชื่อ!"),
                          onSaved: (value) {
                            setState(() => event.Name = value );

                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              icon: const Icon(Icons.message_outlined),
                              hintText: widget.studenthasposts["Description"]),
                          initialValue: widget.studenthasposts["Description"],
                          validator:
                              RequiredValidator(errorText: "กรุณาใส่คำอธิบาย!"),
                          onSaved: (value) {
                            setState(() => event.Description = value);
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              icon: const Icon(Icons.where_to_vote_sharp),
                              hintText: widget.studenthasposts["Location"]),
                          initialValue: widget.studenthasposts["Location"],
                          validator:
                              RequiredValidator(errorText: "กรุณาใส่Location!"),
                          onSaved: (value) {
                            setState(() => event.Location = value);
                          },
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: ListTile(
                            leading: const Icon(
                              Icons.category,
                              size: 30,
                            ),
                            title: const Text(
                              "Interests",
                              style: TextStyle(fontSize: 20),
                            ),
                            trailing: Wrap(
                              spacing: 13,
                              children: const <Widget>[
                                Icon(
                                  Icons.navigate_next_rounded,
                                  size: 35,
                                ),
                              ],
                            ),
                            onTap: () {
                              _formKey.currentState!.save();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Postinterests(
                                          widget.studenthasposts)));
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 300,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //ปุ่ม++++++++++++++++++++++++++++++++++++++++++++++++++++++
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.orangeAccent),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(1),
                                        side: const BorderSide(
                                            color: Colors.green),
                                      ))),
                                  child: const Text("Save",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black),
                                      textAlign: TextAlign.right),
                                  onPressed: () async {
                                    // await model.imageNotification();
                                    isLoading = true;
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      try {
                                                await model.imageNotification();

                                              await FirebaseFirestore.instance
                                                  .collection('Event')
                                                  .doc(widget
                                                      .studenthasposts["Event_id"])
                                                  .update({
                                                //"Image": event.Image,
                                                "Name": event.Name,
                                                "Description": event.Description,
                                                //"Time": event.Time,
                                                "Location": event.Location,
                                              });

                                              await FirebaseFirestore.instance
                                                  .collection('Student')
                                                  .doc(FirebaseAuth
                                                      .instance.currentUser?.uid)
                                                  .collection('Posts')
                                                  .doc(widget.studenthasposts.id)
                                                  .update({
                                                "Image": event.Image,
                                                "Name": event.Name,
                                                "Description": event.Description,
                                                "Time": event.Time,
                                                "Location": event.Location
                                              }).then((value) => {
                                                        Fluttertoast.showToast(
                                                            msg: "Success!",
                                                            gravity:
                                                                ToastGravity.CENTER),
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                          builder: (context) {
                                                            return const MyEvent();
                                                          },
                                                        ))
                                                      });

                                        //  เวลาแจ้งเตือน //
                                        String Time = DateFormat("yyyy-MM-dd hh:mm:ss")
                                            .format(DateTime.now());
                                        print(Time);

                                        await FirebaseFirestore.instance
                                            .collection('Notification')
                                            .doc(widget
                                            .studenthasposts["Event_id"])
                                            .set({
                                          "Name": event.Name,
                                          "Photo": event.Image,
                                          "Status":"",
                                          "Time": Time,
                                        }).then((value) => {
                                                  Fluttertoast.showToast(
                                                      msg: "Success!",
                                                      gravity:
                                                          ToastGravity.CENTER),
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                    builder: (context) {
                                                      return const MyEvent();
                                                    },
                                                  ))
                                                });
                                      } on FirebaseAuthException catch (err) {
                                        Fluttertoast.showToast(
                                            msg: err.message!);
                                      }
                                    }
                                    
                                  }),
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.red),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(1),
                                        side: const BorderSide(
                                            color: Colors.green),
                                      ))),
                                  child: const Text("DELETE",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black),
                                      textAlign: TextAlign.right),
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('Student')
                                        .doc(FirebaseAuth
                                            .instance.currentUser?.uid)
                                        .collection('Posts')
                                        .doc(widget.studenthasposts.id)
                                        .delete();

                                    await FirebaseFirestore.instance
                                        .collection('Event')
                                        .doc(widget.studenthasposts["Event_id"])
                                        .delete()
                                        .then((value) {
                                      Fluttertoast.showToast(
                                          msg: "Delete Success!",
                                          gravity: ToastGravity.CENTER);
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return const MyEvent();
                                        },
                                      ));
                                    });
                                  }),
                            ],
                          ),
                        )
                      ]))));
        });
  }
}
