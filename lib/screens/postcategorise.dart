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
import 'package:project/screens/Myevents.dart';
import 'package:project/screens/addcategorise.dart';
import 'package:project/screens/tabbar.dart';
import 'package:project/Model/Student.dart';

import 'Interests/Interests.dart';
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
    String stDate = DateFormat('MM/dd/yyyy').format(newDate);

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
                Container(
                  child: urlImage == null
                      ? Container(
                          child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.deepPurple[400]),
                              onPressed: () => pickImage(ImageSource.gallery),
                              icon: const Icon(Icons.add_a_photo_outlined),
                              label: const Text("Pick Photo")),
                        )
                      : Image.network(
                          urlImage!,
                          fit: BoxFit.fill,
                          width: 300,
                          height: 150,
                        ),
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
                  maxLines: 2,
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
                //เลือกวันที่
                SizedBox(
                  width: 500,
                  height: 35,
                  child: ElevatedButton(
                      onPressed: () => pickDate(context),
                      child: Text(getTextDate()),
                      style: ElevatedButton.styleFrom(primary: Colors.white)),
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
                    style: ElevatedButton.styleFrom(primary: Colors.white),
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
                                            return Postinterests(document);
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
