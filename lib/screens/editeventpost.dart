// ignore_for_file: unused_import, must_be_immutable, avoid_unnecessary_containers, override_on_non_overriding_member, avoid_print, non_constant_identifier_names, duplicate_import, prefer_const_constructors, unused_local_variable, equal_keys_in_map, deprecated_member_use, avoid_function_literals_in_foreach_calls, duplicate_ignore

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:project/Model/Event.dart';
import 'package:project/Notification/services/Noti.dart';
import 'package:project/Notification/services/notification.dart';
import 'package:project/constants.dart';
import 'package:provider/provider.dart';
import '../Background/bg_EditEvent.dart';
import '../blocs/auth_bloc.dart';
import 'Interests/editinterests.dart';
import 'Myevents.dart';
import 'login.dart';

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
  List count_interests = [];
  List Joined = [];

  //set date
  DateTime? dateTime;
  String? date;
  String getTextDate() {
    if (date == null) {
      date = widget.studenthasposts['date'];
      return widget.studenthasposts['date'];
    } else {
      return date!;
    }
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    //  String date = DateFormat("dd").format(DateTime.now());
    // int dd = int.parse(date);
    // String MM = DateFormat("MM").format(DateTime.now());
    // int mm = int.parse(MM);
    // String Y = DateFormat("yyyy").format(DateTime.now());
    // int yyyy = int.parse(Y);
    final newDate = await showDatePicker(
      context: context,
      initialDate: dateTime ?? initialDate,
      firstDate: DateTime.now().subtract(Duration(days: 0)),
      //  firstDate: DateTime.utc(yyyy, mm, dd),
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
  getTextTime() {
    if (time == null) {
      return widget.studenthasposts["Time"];
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

  var model = NotificationService();
  String length = "";

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState

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
    getlength();
    IMG();
  }

  File? image;
  String? urlImage;
  String? urlImaged;
  void IMG() {
    urlImage = widget.studenthasposts["Image"];
    setState(() {});
  }

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
    FirebaseStorage.instance.refFromURL(urlImaged!).delete();
  }

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

              //backgroundColor: backgroundColor,
              appBar: AppBar(
                backgroundColor: iconColor,
                title: const Text(
                  "Edit",
                  style: TextStyle(fontSize: 25, color: Colors.black),
                ),
              ),
              body: Background(
                child: SingleChildScrollView(
                    padding: const EdgeInsets.only(
                        bottom: 70, top: 10, right: 10, left: 10),
                    child: Form(
                        key: _formKey,
                        child: Column(children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                urlImaged = urlImage;
                              });
                              pickImage(ImageSource.gallery);
                            },
                            child: Container(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0)),
                                child: Image.network(
                                  urlImage!,
                                  height: 250,
                                  width: 300,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),

                          SizedBox(
                            width: 350,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '  คลิกที่รูปเพื่อเปลี่ยน !!!',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
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
                                      Icons.account_circle_rounded,
                                      size: 30,
                                      color: iconColor,
                                    ),
                                    hintText: widget.studenthasposts["Name"],
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  initialValue: widget.studenthasposts["Name"],
                                  validator: RequiredValidator(
                                      errorText: "กรุณาใส่ชื่อ!"),
                                  onSaved: (value) {
                                    setState(() => event.Name = value);
                                  },
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(30),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 5,
                          ),

                          SizedBox(
                            width: 350,
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
                                    hintText:
                                        widget.studenthasposts["Description"],
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  maxLines: 4,
                                  initialValue:
                                      widget.studenthasposts["Description"],
                                  validator: RequiredValidator(
                                      errorText: "กรุณาใส่คำอธิบาย!"),
                                  onSaved: (value) {
                                    setState(() => event.Description = value);
                                  },
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(500),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),

                          SizedBox(
                            width: 350,
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
                                    hintText:
                                        widget.studenthasposts["Location"],
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  initialValue:
                                      widget.studenthasposts["Location"],
                                  validator: RequiredValidator(
                                      errorText: "กรุณาใส่Location!"),
                                  onSaved: (value) {
                                    setState(() => event.Location = value);
                                  },
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(40),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
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
                                                borderRadius:
                                                    BorderRadius.circular(15))),
                                        icon: Icon(Icons.calendar_month_rounded,
                                            size: 30, color: iconColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
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
                                                      BorderRadius.circular(
                                                          15))),
                                          icon: Icon(Icons.watch_later_rounded,
                                              size: 30, color: iconColor)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: ListTile(
                              leading: const Icon(
                                Icons.category,
                                color: iconColor,
                                size: 30,
                              ),
                              title: const Text(
                                "Interests",
                                style: TextStyle(),
                              ),
                              trailing: Wrap(
                                spacing: 13,
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 17,
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text(length,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'Raleway',
                                                fontSize: 20),
                                            textAlign: TextAlign.start)),
                                  ),
                                  Icon(
                                    Icons.navigate_next_rounded,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ],
                              ),
                              onTap: () async {
                                _formKey.currentState!.save();
                                // QuerySnapshot snap = await FirebaseFirestore
                                //     .instance
                                //     .collection("Category")
                                //     .get();

                                // for (int a = 0; a < snap.docs.length; a++) {
                                //   for (int x = 0;
                                //       x <
                                //           widget.studenthasposts["Interests"]
                                //               .length;
                                //       x++) {
                                //     var id = snap.docs[a];
                                //     // print(id.id);
                                //     // print(widget.studenthasposts["Interests"][x]);
                                //     if (id.id ==
                                //         widget.studenthasposts["Interests"][x]) {
                                //       int sum = x + 1;
                                //       count_interests.add(x.toString());
                                //     }
                                //   }
                                // }
                                print(count_interests);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => editinterest(
                                            widget.studenthasposts,
                                            count_interests)));
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                //ปุ่ม++++++++++++++++++++++++++++++++++++++++++++++++++++++
                                SizedBox(
                                  width: 130,
                                  height: 40,
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  backgroundColor),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            side: const BorderSide(
                                                color: iconColor, width: 2),
                                          ))),
                                      child: const Text("Save",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black),
                                          textAlign: TextAlign.right),
                                      onPressed: () async {
                                        print(urlImage);
                                        //  await createPlantFoodNotification();

                                        //  await model.imageNotification(event);
                                        isLoading = true;

                                        //เรียก method editdatatoFirebase
                                        editdatatoFirebase();
                                        print(event.Name);

                                        //  เวลาแจ้งเตือน //
                                        String Time = DateFormat("hh:mm:ss")
                                            .format(DateTime.now());
                                        String date = DateFormat("dd/MM/yyyy")
                                            .format(DateTime.now());
                                        print(Time + date);
                                        print(event.Name);

                                        //


                                        var join = await FirebaseFirestore
                                            .instance
                                            .collection("Event")
                                            .doc(widget
                                                .studenthasposts["Event_id"])
                                            .collection("Joined")
                                            .get();
                                        FirebaseFirestore.instance
                                            .collection('Notification')
                                            .doc(widget
                                                .studenthasposts["Event_id"])
                                            .update({
                                          'Student_id': FieldValue.delete()
                                        }).whenComplete(() {
                                          print('Field Deleted');
                                        });

                                        join.docs.forEach((element) async {
                                          var a = element.data();
                                          await FirebaseFirestore.instance
                                              .collection("Student")
                                              .doc(a["Student_id"])
                                              .collection("Joined")
                                              .doc(widget
                                                  .studenthasposts["Event_id"])
                                              .update({
                                            "Image": urlImage,
                                            "Name": event.Name,
                                            "Description": event.Description,
                                            "Time":
                                                widget.studenthasposts["Time"],
                                            "Location": event.Location,
                                            "date":
                                                widget.studenthasposts["date"],
                                          });
                                          await FirebaseFirestore.instance
                                              .collection('Notification')
                                              .doc(widget
                                                  .studenthasposts["Event_id"])
                                              .update({
                                            "Student_id":
                                                FieldValue.arrayUnion([
                                                  element.id
                                             
                                            ])
                                          });
                                        });
                                        if (join.docs.isNotEmpty) {
                                          await FirebaseFirestore.instance
                                              .collection("Notification")
                                              .doc(widget
                                                  .studenthasposts["Event_id"])
                                              .update({
                                            "Photo": urlImage,
                                            "Name": event.Name,
                                            "Status": "edited",
                                            "Time": Time,
                                            "date": date,
                                            "Type": '1'
                                          });
                                        }
                                        RemoveImageinStorage();

                                        Fluttertoast.showToast(
                                            msg: "Success!",
                                            gravity: ToastGravity.CENTER);
                                        Navigator.pop(context);
                                      }),
                                ),
                                SizedBox(
                                  width: 25,
                                ),
                                SizedBox(
                                  width: 130,
                                  height: 40,
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  backgroundColor),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            side: const BorderSide(
                                                color: iconColor, width: 2),
                                          ))),
                                      child: const Text("DELETE",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black),
                                          textAlign: TextAlign.right),
                                      onPressed: () async {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                    "Delete This Event !!"),
                                                content: Text("Are you sure?"),
                                                actions: [
                                                  FlatButton(
                                                    onPressed: () async {
                                                      
                                                      DeleteNotification();
                                                      DeleteComment();

                                                      //ดึงคนที่ join เข้ามาในกิจกรรมนี้
                                                      QuerySnapshot snaps =
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "Event")
                                                              .doc(widget
                                                                      .studenthasposts[
                                                                  "Event_id"])
                                                              .collection(
                                                                  "Joined")
                                                              .get();

                                                      // loop ค่าของ snaps
                                                      snaps.docs.forEach(
                                                          (element) async {
                                                        // delete ตาราง joined ใน student
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "Student")
                                                            .doc(element.id)
                                                            .collection(
                                                                "Joined")
                                                            .doc(widget
                                                                    .studenthasposts[
                                                                "Event_id"])
                                                            .delete();
                                                      });
                                                      //ดึงคนที่ join เข้ามาในกิจกรรมนี้
                                                      QuerySnapshot snap =
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "Event")
                                                              .doc(widget
                                                                      .studenthasposts[
                                                                  "Event_id"])
                                                              .collection(
                                                                  "Joined")
                                                              .get();
                                                      snap.docs.forEach((data) {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection("Event")
                                                            .doc(widget
                                                                    .studenthasposts[
                                                                "Event_id"])
                                                            .collection(
                                                                "Joined")
                                                            .doc(data.id)
                                                            .delete();
                                                      });

                                                      //delete ตาราง event เลย
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('Event')
                                                          .doc(widget
                                                                  .studenthasposts[
                                                              "Event_id"])
                                                          .delete();
                                                      DeleteEventInstudentPost();

                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Delete Success!",
                                                          gravity: ToastGravity
                                                              .CENTER);

                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('Yes'),
                                                  ),
                                                  FlatButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("Cancle"))
                                                ],
                                              );
                                            });
                                      }),
                                ),
                              ],
                            ),
                          )
                        ]))),
              ));
        });
  }

  editdatatoFirebase() async {
    if (event.Time == null && event.Date == null) {
      // event.Time =
      //     widget.studenthasposts["Time"];
      // event.Date =
      //     widget.studenthasposts["date"];if (_formKey.currentState!.validate()) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        try {
          // await model.imageNotification(event);
          event.Image = urlImage;
          await createPlantFoodNotification(event);

          await FirebaseFirestore.instance
              .collection('Event')
              .doc(widget.studenthasposts["Event_id"])
              .update({
            "Image": urlImage,
            "Name": event.Name,
            "Description": event.Description,
            "Time": widget.studenthasposts["Time"],
            "Location": event.Location,
            "date": widget.studenthasposts["date"]
          });

          await FirebaseFirestore.instance
              .collection('Student')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .collection('Posts')
              .doc(widget.studenthasposts.id)
              .update({
            "Image": urlImage,
            "Name": event.Name,
            "Description": event.Description,
            "Time": widget.studenthasposts["Time"],
            "Location": event.Location,
            "date": widget.studenthasposts["date"],
          });
        } on FirebaseAuthException catch (err) {
          Fluttertoast.showToast(msg: err.message!);
        }
      }
    } else if (event.Time != null && event.Date != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        try {
          // await model.imageNotification(event);
          await createPlantFoodNotification(event);

          await FirebaseFirestore.instance
              .collection('Event')
              .doc(widget.studenthasposts["Event_id"])
              .update({
            "Image": urlImage,
            "Name": event.Name,
            "Description": event.Description,
            "Time": event.Time?.format(context),
            "Location": event.Location,
            "date": event.Date
          });

          await FirebaseFirestore.instance
              .collection('Student')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .collection('Posts')
              .doc(widget.studenthasposts.id)
              .update({
            "Image": urlImage,
            "Name": event.Name,
            "Description": event.Description,
            "Time": event.Time?.format(context),
            "Location": event.Location,
            "date": event.Date,
          });
        } on FirebaseAuthException catch (err) {
          Fluttertoast.showToast(msg: err.message!);
        }
      }
      // Time มีค่า  แต่ date ไม่มีค่า
    } else if (event.Time != null && event.Date == null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        try {
          // await model.imageNotification(event);
          await createPlantFoodNotification(event);

          await FirebaseFirestore.instance
              .collection('Event')
              .doc(widget.studenthasposts["Event_id"])
              .update({
            "Image": urlImage,
            "Name": event.Name,
            "Description": event.Description,
            "Time": event.Time?.format(context),
            "Location": event.Location,
            "date": widget.studenthasposts["date"]
          });

          await FirebaseFirestore.instance
              .collection('Student')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .collection('Posts')
              .doc(widget.studenthasposts.id)
              .update({
            "Image": urlImage,
            "Name": event.Name,
            "Description": event.Description,
            "Time": event.Time?.format(context),
            "Location": event.Location,
            "date": widget.studenthasposts["date"]
          });
        } on FirebaseAuthException catch (err) {
          Fluttertoast.showToast(msg: err.message!);
        }
      }

      // ถ้า Time ไม่มีค่า แต่ date มีค่า
    } else if (event.Time == null && event.Date != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        try {
          // await model.imageNotification(event);
          await createPlantFoodNotification(event);

          await FirebaseFirestore.instance
              .collection('Event')
              .doc(widget.studenthasposts["Event_id"])
              .update({
            "Image": urlImage,
            "Name": event.Name,
            "Description": event.Description,
            "Time": widget.studenthasposts["Time"],
            "Location": event.Location,
            "date": event.Date
          });

          await FirebaseFirestore.instance
              .collection('Student')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .collection('Posts')
              .doc(widget.studenthasposts.id)
              .update({
            "Image": urlImage,
            "Name": event.Name,
            "Description": event.Description,
            "Time": widget.studenthasposts["Time"],
            "Location": event.Location,
            "date": event.Date
          });
        } on FirebaseAuthException catch (err) {
          Fluttertoast.showToast(msg: err.message!);
        }
      }
    }
  }

  getlength() {
    length = widget.studenthasposts['Interests'].length.toString();
    setState(() {});
  }

  void DeleteEventInstudentPost() async {
    // QuerySnapshot DeleteStudent = await FirebaseFirestore.instance
    //     .collection("Student")
    //     .doc(widget.Event["Host"][0]["Student_id"])
    //     .collection("Posts")
    //     .where("Event_id", isEqualTo: widget.Event.id)
    //     .get();
    // DeleteStudent.docs.forEach((element) async {
    //   await FirebaseFirestore.instance
    //     ..collection("Student")
    //         .doc(widget.Event["Host"][0]["Student_id"])
    //         .collection("Posts")
    //         .doc(element.id)
    //         .delete();
    // });
    await FirebaseFirestore.instance
        .collection('Student')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Posts')
        .doc(widget.studenthasposts.id)
        .delete();
  }

  // ignore: non_constant_identifier_names
  void DeleteComment() async {
    await FirebaseFirestore.instance
        .collection("Comment")
        .where("eId", isEqualTo: widget.studenthasposts["Event_id"])
        .get()
        .then((value) => {
              value.docs.forEach((element) async {
                await FirebaseFirestore.instance
                    .collection("Comment")
                    .doc(element.id)
                    .delete();
              })
            });
  }

  void DeleteNotification() async {
    await FirebaseFirestore.instance
        .collection("Notification")
        .doc(widget.studenthasposts["Event_id"])
        .delete();
  }
}
