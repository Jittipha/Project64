// ignore_for_file: unused_import, non_constant_identifier_names, avoid_print, avoid_unnecessary_containers, avoid_function_literals_in_foreach_calls, prefer_const_constructors, deprecated_member_use

import 'dart:io';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';

import 'package:project/Model/Event.dart';
import 'package:project/screens/Interests/newinterest.dart';
import 'package:project/screens/Myevents.dart';

import 'package:project/screens/tabbar.dart';
import 'package:project/Model/Student.dart';

import '../PageNotWorking/Interests.dart';
import 'editeventpost.dart';

//import 'package:flutter_application_1/screen/addcategorise.dart';
//import 'package:flutter_application_1/screen/createeventspost.dart';
//import 'package:flutter_application_1/screen/homepage.dart';

// ignore: use_key_in_widget_constructors
class Post extends StatefulWidget {
  // ignore: use_key_in_widget_constructors

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  TextEditingController dateinput = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Students student = Students();
  events event = events();
  bool isLoading = false;
  File? image;
  String? urlImage;
  String? text;

  Future<void> pickImage(ImageSource imageSource) async {
    try {
      final Image = await ImagePicker().pickImage(source: imageSource);
      if (Image == null) return;

      final imageTemporary = File(Image.path);
      setState(() {
        image = imageTemporary;
        print("image : $image");
        isLoading = true;
      });

      upLoadImageToStorage();
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<void> upLoadImageToStorage() async {
    String time = DateTime.now()
        .toString()
        .replaceAll("-", "_")
        .replaceAll(":", "_")
        .replaceAll(" ", "_");
    print('time : $time');

    FirebaseStorage firebaseStorage = FirebaseStorage.instance;

    Reference reference = firebaseStorage.ref().child('Event/Event$time.jpg');

    UploadTask uploadTask = reference.putFile(image!);
    await uploadTask.then((TaskSnapshot taskSnapshot) async => {
          await taskSnapshot.ref.getDownloadURL().then((dynamic url) => {
                print("url : $url"),
                urlImage = url.toString(),
                setState(() {
                  isLoading = false;
                })
              })
        });
  }

//set date
  DateTime? dateTime;
  String? date;
  //DateTime? newDate;
  String getTextDate() {
    if (date == null) {
      return "Select Date";
    } else {
      return date!;
    }
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: dateTime ?? initialDate,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 6),
    );
    if (newDate == null) return;
    String stDate = DateFormat('dd/MM/yyyy').format(newDate);

    setState(() {
      date = stDate;
      event.Date = stDate;
    });
  }

  //set time
  TimeOfDay? time;
  String getTextTime() {
    if (time == null) {
      return "Select Time";
    } else {
      final hours = time?.hour.toString().padLeft(2, '0');
      final minutes = time?.minute.toString().padLeft(2, '0');

      return '$hours:$minutes';
    }
  }

  Future pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 9, minute: 0);
    final newTime = await showTimePicker(
        context: context, initialTime: time ?? initialTime);

    if (newTime == null) return;

    setState(() {
      time = newTime;
      event.Time = newTime;
    });
  }

  @override
  void initState() {
    dateinput.text = ""; //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 48, 180, 169),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 13, 104, 96),
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
                Container(
                  child: urlImage == null
                      ? Container(
                          child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  primary: Color.fromARGB(255, 189, 226, 229)),
                              onPressed: () => pickImage(ImageSource.gallery),
                              icon: const Icon(
                                Icons.add_a_photo_outlined,
                                size: 30,
                              ),
                              label: const Text("Pick Photo")),
                        )
                      : Image.network(
                          urlImage!,
                          fit: BoxFit.fill,
                          width: 300,
                          height: 150,
                        ),
                ),
                SizedBox(
                  height: 10,
                ),

                // TextFormField(
                //     // decoration: const InputDecoration(
                //     //   icon: Icon(Icons.photo_size_select_small_outlined),
                //     //   hintText: '',
                //     // ),
                //     // validator: RequiredValidator(errorText: "กรุณาใส่รูป!"),
                //     // onSaved: (value) {
                //     //   event.Image = value;
                //     // },
                //     ),
                TextFormField(
                  decoration: const InputDecoration(
                      icon: Icon(
                        Icons.account_circle_sharp,
                        size: 35,
                        color: Color.fromARGB(255, 55, 104, 112),
                      ),
                      hintText: 'Name',
                      border: OutlineInputBorder()),
                  validator: RequiredValidator(errorText: "กรุณาใส่ชื่อ!"),
                  onSaved: (value) {
                    event.Name = value;
                  },
                ),
                SizedBox(
                  height: 10,
                ),

                TextFormField(
                  decoration: const InputDecoration(
                      icon: Icon(
                        Icons.message_outlined,
                        size: 35,
                        color: Color.fromARGB(255, 55, 104, 112),
                      ),
                      hintText: 'Description',
                      border: OutlineInputBorder()),
                  maxLines: 2,
                  validator: RequiredValidator(errorText: "กรุณาใส่คำอธิบาย!"),
                  onSaved: (value) {
                    event.Description = value;
                  },
                ),
                SizedBox(
                  height: 10,
                ),

                TextFormField(
                  decoration: const InputDecoration(
                      icon: Icon(
                        Icons.where_to_vote_sharp,
                        size: 35,
                        color: Color.fromARGB(255, 55, 104, 112),
                      ),
                      hintText: 'Location',
                      border: OutlineInputBorder()),
                  validator: RequiredValidator(errorText: "กรุณาใส่ที่อยู่!"),
                  onSaved: (value) {
                    event.Location = value;
                  },
                ),
                SizedBox(
                  height: 10,
                ),

                //เลือกวันที่
                SizedBox(
                  width: 500,
                  height: 35,
                  child: ElevatedButton(
                      onPressed: () => pickDate(context),
                      child: Text(getTextDate()),
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 230, 220, 220))),
                ),
                const SizedBox(
                  height: 10,
                ),

                //เลือกเวลา
                SizedBox(
                  width: 500,
                  height: 35,
                  child: ElevatedButton(
                    onPressed: () => pickTime(context),
                    child: Text(getTextTime()),
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 230, 220, 220)),
                  ),
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
                            //ุถ้ารูปไม่มีค่า
                            if (urlImage == null) {
                              text = 'กรุณาใส่รูปกิจกรรม';
                              //เรียกใช้งาน alerty และส่ง text ไปด่้วย
                              showAlertDialog(context, text);
                              // ถ้าวันไม่มีค่า
                            } else if (event.Date == null) {
                              text = 'กรุณาใส่วันที่เริ่มกิจกรรม';
                              //เรียกใช้งาน alerty และส่ง text ไปด่้วย
                              showAlertDialog(context, text);
                              //ถ้า เวลาไม่มีค่า
                            } else if (event.Time == null) {
                              text = 'กรุณาใส่เวลาที่เริ่มกิจกรรม';
                              //เรียกใช้งาน alerty และส่ง text ไปด่้วย
                              showAlertDialog(context, text);
                              //ถ้า รูป วัน เวลา มีค่า
                            } else if (urlImage != null &&
                                event.Time != null &&
                                event.Date != null) {
                              await FirebaseFirestore.instance
                                  .collection('Event')
                                  .doc()
                                  .set({
                                "Image": urlImage,
                                "Name": event.Name,
                                "Description": event.Description,
                                "Time": event.Time?.format(context),
                                "Location": event.Location,
                                "date": event.Date,
                                "Host": [
                                  {
                                    "Student_id":
                                        FirebaseAuth.instance.currentUser?.uid,
                                    "Name": FirebaseAuth
                                        .instance.currentUser?.displayName,
                                    "Photo": FirebaseAuth
                                        .instance.currentUser?.photoURL,
                                    "Email":
                                        FirebaseAuth.instance.currentUser?.email
                                  }
                                ]
                              });
                              QuerySnapshot snap = await FirebaseFirestore
                                  .instance
                                  .collection('Event')
                                  .where("Name", isEqualTo: event.Name)
                                  .where("Location", isEqualTo: event.Location)
                                  .get();
                              snap.docs.forEach((document) async {
                                await FirebaseFirestore.instance
                                    .collection('Student')
                                    .doc(FirebaseAuth.instance.currentUser?.uid)
                                    .collection('Posts')
                                    .doc()
                                    .set({
                                  "Image": urlImage,
                                  "Name": event.Name,
                                  "Description": event.Description,
                                  "Time": event.Time?.format(context),
                                  "Location": event.Location,
                                  "Event_id": document.id,
                                  "date": event.Date
                                }).then((value) => {
                                          Navigator.pushReplacement(context,
                                              MaterialPageRoute(
                                            builder: (context) {
                                              return interestedited(document);
                                            },
                                          ))
                                        });
                              });
                            }
                          }
                        }),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  showAlertDialog(BuildContext context, text) {
    // set up the button
    Widget OKButton = FlatButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.pop(context, 'Cancel');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Warning!!"),
      content: Text(text),
      actions: [OKButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
