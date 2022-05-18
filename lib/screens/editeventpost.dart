// ignore_for_file: unused_import, must_be_immutable, avoid_unnecessary_containers, override_on_non_overriding_member, avoid_print, non_constant_identifier_names, duplicate_import, prefer_const_constructors, unused_local_variable, equal_keys_in_map, deprecated_member_use, avoid_function_literals_in_foreach_calls
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:project/Model/Event.dart';
import 'package:project/Notification/services/notification.dart';
import '../Background/bg_EditEvent.dart';
import 'Interests/editinterests.dart';
import 'Myevents.dart';

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
    final newDate = await showDatePicker(
      context: context,
      initialDate: dateTime ?? initialDate,
      firstDate: DateTime(DateTime.now().year),
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
    super.initState();
    getlength();
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
              backgroundColor: Color.fromARGB(255, 30, 150, 140),
              appBar: AppBar(
                backgroundColor: Color.fromARGB(255, 13, 104, 96),
                title: const Text(
                  "Event",
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
                          Container(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                  bottomLeft: Radius.circular(20.0),
                                  bottomRight: Radius.circular(20.0)),
                              child: Image.network(
                                '${widget.studenthasposts["Image"]}',
                                height: 300,
                                width: 300,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              icon: const Icon(
                                  Icons.photo_size_select_small_outlined,
                                  color: Colors.white),
                              hintText: widget.studenthasposts["Image"],
                            ),
                            initialValue: widget.studenthasposts["Image"],
                            style: TextStyle(color: Colors.white),
                            validator: RequiredValidator(
                                errorText: "กรุณาใส่ลิงก์รูป!"),
                            onSaved: (value) {
                              setState(() => event.Image = value);
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              icon: const Icon(Icons.account_circle_sharp,
                                  color: Colors.white),
                              hintText: widget.studenthasposts["Name"],
                            ),
                            initialValue: widget.studenthasposts["Name"],
                            style: TextStyle(color: Colors.white),
                            validator:
                                RequiredValidator(errorText: "กรุณาใส่ชื่อ!"),
                            onSaved: (value) {
                              setState(() => event.Name = value);
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                icon: const Icon(Icons.message_outlined,
                                    color: Colors.white),
                                hintText:
                                    widget.studenthasposts["Description"]),
                            initialValue: widget.studenthasposts["Description"],
                            style: TextStyle(color: Colors.white),
                            validator: RequiredValidator(
                                errorText: "กรุณาใส่คำอธิบาย!"),
                            onSaved: (value) {
                              setState(() => event.Description = value);
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                icon: const Icon(Icons.where_to_vote_sharp,
                                    color: Colors.white),
                                hintText: widget.studenthasposts["Location"]),
                            initialValue: widget.studenthasposts["Location"],
                            style: TextStyle(color: Colors.white),
                            validator: RequiredValidator(
                                errorText: "กรุณาใส่Location!"),
                            onSaved: (value) {
                              setState(() => event.Location = value);
                            },
                          ),
                          //เลือกวันที่
                          SizedBox(
                            width: 500,
                            height: 35,
                            child: ElevatedButton(
                                onPressed: () => pickDate(context),
                                child: Text(getTextDate()),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.white)),
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
                                  primary: Colors.white),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: ListTile(
                              leading: const Icon(
                                Icons.category,
                                color: Colors.white,
                                size: 30,
                              ),
                              title: const Text(
                                "Interests",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                              trailing: Wrap(
                                spacing: 13,
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: Colors.grey[300],
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
                                          borderRadius:
                                              BorderRadius.circular(1),
                                          side: const BorderSide(
                                              color: Colors.green),
                                        ))),
                                    child: const Text("Save",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.black),
                                        textAlign: TextAlign.right),
                                    onPressed: () async {
                                      //  await model.imageNotification();
                                      isLoading = true;

                                      //เรียก method editdatatoFirebase
                                      editdatatoFirebase();
                                      //  เวลาแจ้งเตือน //
                                      String Time = DateFormat("hh:mm:ss")
                                          .format(DateTime.now());
                                      String date = DateFormat("dd/MM/yyyy")
                                          .format(DateTime.now());
                                      print(Time + date);
                                      print(event.Name);

                                      await FirebaseFirestore.instance
                                          .collection("Notification")
                                          .doc(widget
                                              .studenthasposts["Event_id"])
                                          .update({
                                        "Photo": event.Image,
                                        "Name": event.Name,
                                        "Status": "edited",
                                        "Time": Time,
                                        "date": date,
                                        "Type": '1'
                                      }).then((value) => {
                                                Fluttertoast.showToast(
                                                    msg: "Success!",
                                                    gravity:
                                                        ToastGravity.CENTER),
                                                Navigator.pop(context)
                                              });
                                    }),
                                ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.red),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(1),
                                          side: const BorderSide(
                                              color: Colors.green),
                                        ))),
                                    child: const Text("DELETE",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.black),
                                        textAlign: TextAlign.right),
                                    onPressed: () async {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("Are you sure?"),
                                              content: Text(""),
                                              actions: [
                                                FlatButton(
                                                  onPressed: () {
                                                    FirebaseFirestore.instance
                                                        .collection('Student')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.uid)
                                                        .collection('Posts')
                                                        .doc(widget
                                                            .studenthasposts.id)
                                                        .delete();

                                                    FirebaseFirestore.instance
                                                        .collection('Event')
                                                        .doc(widget
                                                                .studenthasposts[
                                                            "Event_id"])
                                                        .delete()
                                                        .then((value) {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Delete Success!",
                                                          gravity: ToastGravity
                                                              .CENTER);
                                                      Navigator.pop(context);
                                                    });
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

                                      // await FirebaseFirestore.instance
                                      //     .collection('Student')
                                      //     .doc(FirebaseAuth
                                      //         .instance.currentUser?.uid)
                                      //     .collection('Posts')
                                      //     .doc(widget.studenthasposts.id)
                                      //     .delete();

                                      // await FirebaseFirestore.instance
                                      //     .collection('Event')
                                      //     .doc(widget.studenthasposts["Event_id"])
                                      //     .delete()
                                      //     .then((value) {
                                      //   Fluttertoast.showToast(
                                      //       msg: "Delete Success!",
                                      //       gravity: ToastGravity.CENTER);
                                      //   Navigator.push(context, MaterialPageRoute(
                                      //     builder: (context) {
                                      //       return const MyEvent();
                                      //     },
                                      //   ));

                                      await FirebaseFirestore.instance
                                          .collection('Student')
                                          .doc(FirebaseAuth
                                              .instance.currentUser?.uid)
                                          .collection('Posts')
                                          .doc(widget.studenthasposts.id)
                                          .delete();
                                      QuerySnapshot snaps =
                                          await FirebaseFirestore.instance
                                              .collection("Event")
                                              .doc(widget
                                                  .studenthasposts["Event_id"])
                                              .collection("Joined")
                                              .get();
                                      snaps.docs.forEach((element) async {
                                        await FirebaseFirestore.instance
                                            .collection("Student")
                                            .doc(element.id)
                                            .collection("Joined")
                                            .doc(widget
                                                .studenthasposts["Event_id"])
                                            .delete();
                                      });
                                      await FirebaseFirestore.instance
                                          .collection('Event')
                                          .doc(widget
                                              .studenthasposts["Event_id"])
                                          .delete()
                                          .then((value) {
                                        Fluttertoast.showToast(
                                            msg: "Delete Success!",
                                            gravity: ToastGravity.CENTER);
                                        Navigator.pop(context, 'Cancel');
                                      });
                                    }),
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

          await FirebaseFirestore.instance
              .collection('Event')
              .doc(widget.studenthasposts["Event_id"])
              .update({
            "Image": event.Image,
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
            "Image": event.Image,
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

          await FirebaseFirestore.instance
              .collection('Event')
              .doc(widget.studenthasposts["Event_id"])
              .update({
            "Image": event.Image,
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
            "Image": event.Image,
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

          await FirebaseFirestore.instance
              .collection('Event')
              .doc(widget.studenthasposts["Event_id"])
              .update({
            "Image": event.Image,
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
            "Image": event.Image,
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

          await FirebaseFirestore.instance
              .collection('Event')
              .doc(widget.studenthasposts["Event_id"])
              .update({
            "Image": event.Image,
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
            "Image": event.Image,
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
}
