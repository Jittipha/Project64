// ignore_for_file: unused_import, non_constant_identifier_names, avoid_print, avoid_unnecessary_containers, avoid_function_literals_in_foreach_calls, prefer_const_constructors

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
import 'package:project/constants.dart';
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
    String time = DateTime.now() //12:00 12-06-2022
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
  Future<void> RemoveImageinStorage() async {
    FirebaseStorage.instance.refFromURL(urlImage!).delete();
  }
//set date
  DateTime? dateTime;
  String? date;

  //DateTime? newDate;
  String getTextDate() {
    if (date == null) {
      return "Select Date";
    } else {
      return event.Date!;
    }
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    // String date = DateFormat("dd").format(DateTime.now());
    // int dd = int.parse(date);
    // String MM = DateFormat("MM").format(DateTime.now());
    // int mm = int.parse(MM);
    // String Y = DateFormat("yyyy").format(DateTime.now());
    // int yyyy = int.parse(Y);
    final newDate = await showDatePicker(
      context: context,
      initialDate: dateTime ?? initialDate,
      firstDate: DateTime.now().subtract(Duration(days: 0)),
      
      // firstDate: DateTime.utc(yyyy, mm, dd),
      lastDate: DateTime(DateTime.now().year + 5),
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
    final initialTime = TimeOfDay(hour: 7, minute: 0);
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
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: iconColor,
        title: const Text(
          "โพสต์",
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
                          child: SizedBox(
                            height: 45,
                            child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    primary: backgroundColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      side: BorderSide(
                                          color:
                                              Color.fromARGB(255, 55, 104, 112),
                                          width: 2),
                                    )),
                                onPressed: () => pickImage(ImageSource.gallery),
                                icon: const Icon(Icons.add_a_photo_outlined,
                                    size: 25, color: iconColor),
                                label: const Text("Pick Photo")),
                          ),
                        )
                      : GestureDetector(
                            onTap: () {
                                setState(() {
                                  RemoveImageinStorage();
                                  urlImage = null;
                                  
                                });
                                pickImage(ImageSource.gallery);
                              },
                       child: Image.network(
                          urlImage!,
                          fit: BoxFit.fill,
                          width: 300,
                          height: 150,
                        ),
                      )
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '  Name',
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(
                            Icons.account_circle_sharp,
                            size: 30,
                            color: iconColor,
                          ),
                          hintText: 'Name',
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator:
                            RequiredValidator(errorText: "กรุณาใส่ชื่อ!"),
                        onSaved: (value) {
                          event.Name = value;
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(30),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '  Description',
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(
                            Icons.message_outlined,
                            size: 30,
                            color: iconColor,
                          ),
                          hintText: 'Description',
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(15)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        maxLines: 4,
                        validator:
                            RequiredValidator(errorText: "กรุณาใส่คำอธิบาย!"),
                        onSaved: (value) {
                          event.Description = value;
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(500),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '  Location',
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(
                            Icons.where_to_vote_sharp,
                            size: 30,
                            color: iconColor,
                          ),
                          hintText: 'Location',
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(15)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator:
                            RequiredValidator(errorText: "กรุณาใส่ที่อยู่!"),
                        onSaved: (value) {
                          event.Location = value;
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(40),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                //วันเวลา
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //เลือกวันที่
                    SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '  Date',
                            style: TextStyle(fontSize: 15),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          SizedBox(
                            height: 45,
                            width: 160,
                            child: ElevatedButton.icon(
                              onPressed: () => pickDate(context),
                              label: Text(getTextDate()),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15))),
                              icon: Icon(Icons.calendar_month_rounded,
                                  size: 30, color: iconColor),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //เลือกเวลา
                    SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '  Time',
                            style: TextStyle(fontSize: 15),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          SizedBox(
                            height: 45,
                            width: 160,
                            child: ElevatedButton.icon(
                                onPressed: () => pickTime(context),
                                label: Text(getTextTime()),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15))),
                                icon: Icon(Icons.watch_later_rounded,
                                    size: 30, color: iconColor)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 45,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(backgroundColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(color: iconColor, width: 2),
                          ))),
                      child: const Text("Continue",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                          textAlign: TextAlign.center),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          if (urlImage == null) {
                            text = "กรุณาใส่รูป";
                            showAlertDialog(context, text);
                          } else if (event.Date == null) {
                            text = "กรุณาใส่วันที่";
                            showAlertDialog(context, text);
                          } else if (event.Time == null) {
                            text = "กรุณาใส่เวลา";
                            showAlertDialog(context, text);
                          } else {
                            String time =
                                DateFormat("HH").format(DateTime.now());
                            String datenow =
                                DateFormat("dd/MM/yyyy").format(DateTime.now());
                                // เวลานะปัจจุบัน
                            int timenow = int.parse(time);
                            String a = formatTimeOfDay(event.Time);
                            int timeselect = int.parse(a);
                           
                            //เวลาที่ผู้ใช้เลือก
                            print(timeselect);
                            print(time);
                            if (timeselect <= timenow && event.Date == datenow) {
                              text =
                                  'กรุณาเลือกเวลาหลังจากเวลาปัจจุบัน 1 ชั่วโมง';
                              showAlertDialog(context, text);
                            } else {
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
                        }
                      }),
                ),
              ],
            ),
          )),
    );
  }

  String formatTimeOfDay(TimeOfDay? tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod!.hour, tod.minute);
    final format = DateFormat.H();
    return format.format(dt);
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
