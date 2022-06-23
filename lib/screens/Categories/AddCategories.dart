// ignore_for_file: deprecated_member_use, file_names, camel_case_types, non_constant_identifier_names, avoid_print, duplicate_ignore, unnecessary_import

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/Model/Category.dart';

class addcate extends StatefulWidget {
  const addcate({Key? key}) : super(key: key);

  @override
  State<addcate> createState() => _addcateState();
}

class _addcateState extends State<addcate> {
  Cates cate = Cates();
  File? image;
  final _formcate = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 30, 150, 140),
        appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 13, 104, 96),
            title: const Text(
              "Create Category",
              style: TextStyle(
                fontSize: 22,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w600,
              ),
            )),
        body: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formcate,
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                      alignment: Alignment.center,
                      child: cate.urlImage == null
                          ? GestureDetector(
                              onTap: () {
                                pickImage(ImageSource.gallery);
                              },
                              child: const CircleAvatar(
                                  backgroundColor: Colors.blueGrey,
                                  radius: 93,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        "https://static.thenounproject.com/png/396915-200.png"),
                                    radius: 90,
                                  )))

                          // CircleAvatar(
                          //     child: ElevatedButton.icon(
                          //         style: ElevatedButton.styleFrom(
                          //             primary: Colors.deepPurple[400]),
                          //         onPressed: () => pickImage(ImageSource.gallery),
                          //         icon: const Icon(Icons.add_a_photo_outlined),
                          //         label: const Text("Pick Photo")),
                          //   )
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  RemoveImageinStorage();
                                  cate.urlImage = null;
                                });
                                pickImage(ImageSource.gallery);
                              },
                              child: CircleAvatar(
                                  backgroundColor: Colors.blueGrey[100],
                                  radius: 93,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(cate.urlImage!),
                                    radius: 90,
                                    child: const Align(
                                      alignment: Alignment.bottomRight,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 25.0,
                                        child: Icon(
                                          Icons.camera_alt,
                                          size: 25.0,
                                          color: Color(0xFF404040),
                                        ),
                                      ),
                                    ),
                                  )))),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                          icon: Icon(Icons.account_circle_sharp,
                              size: 40, color: Colors.white),
                          hintText: ' Name',
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Raleway',
                              fontSize: 16,
                              color: Colors.white)),
                      validator:
                          RequiredValidator(errorText: "กรุณาชื่อหมวดหมู่!"),
                      onSaved: (value) {
                        cate.Name = value;
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                    child: TextFormField(
                      maxLines: 4,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.message_outlined,
                              size: 40, color: Colors.white),
                          hintText: ' Description',
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Raleway',
                              fontSize: 16,
                              color: Colors.white)),
                      validator: RequiredValidator(
                          errorText: "กรุณาอธิบายรายละเอียดหมวดหมู่!"),
                      onSaved: (value) {
                        cate.Description = value;
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text(
            'CONFIRM',
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontFamily: 'Raleway',
                fontSize: 16),
          ),
          icon: const Icon(Icons.check_circle_outline_outlined),
          backgroundColor: Colors.green[400],
          onPressed: () {
            if (cate.urlImage != null) {
              if (_formcate.currentState!.validate()) {
                _formcate.currentState!.save();
                FirebaseFirestore.instance
                    .collection("PreCategories")
                    .doc()
                    .set({
                  'Image': cate.urlImage,
                  'Name': cate.Name,
                  'Description': cate.Description,
                  'Student': [
                    {
                      "Student_id": FirebaseAuth.instance.currentUser?.uid,
                      "Name": FirebaseAuth.instance.currentUser?.displayName,
                      "Photo": FirebaseAuth.instance.currentUser?.photoURL,
                      "Email": FirebaseAuth.instance.currentUser?.email
                    }
                  ]
                }).then((value) => {
                          Fluttertoast.showToast(
                              msg: "Success, Please wait for approval.",
                              gravity: ToastGravity.CENTER),
                          Navigator.pop(context)
                        });
              }
            } else {
              showAlertDialog(context);
            }
          },
        ));
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
    String time = DateTime.now()
        .toString()
        .replaceAll("-", "_")
        .replaceAll(":", "_")
        .replaceAll(" ", "_");
    // ignore: avoid_print
    print('time : $time');

    FirebaseStorage firebaseStorage = FirebaseStorage.instance;

    Reference reference =
        firebaseStorage.ref().child('Categories/Categories$time.jpg');

    UploadTask uploadTask = reference.putFile(image!);
    await uploadTask.then((TaskSnapshot taskSnapshot) async => {
          await taskSnapshot.ref.getDownloadURL().then((dynamic url) => {
                print("url : $url"),
                cate.urlImage = url.toString(),
                setState(() {
                  isLoading = false;
                })
              })
        });
  }

  // ignore: non_constant_identifier_names
  Future<void> RemoveImageinStorage() async {
    FirebaseStorage.instance.refFromURL(cate.urlImage!).delete();
  }

  showAlertDialog(BuildContext context) {
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
      content: const Text("กรุณาใส่รูป"),
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
