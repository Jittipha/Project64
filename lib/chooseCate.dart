import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:project/screens/DetailCate.dart';
import 'package:project/main.dart';
import 'package:snapshot/snapshot.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  // Future<List<Cate>> _getCates() async {
  //   var url = Uri.parse("https://api-test-project64.herokuapp.com/ListCate");
  //   var res = await http.get(url);

  //   var jsondata = json.decode(res.body);
  //   List<Cate> cates = [];
  //   for (var u in jsondata) {
  //     Cate cate = Cate(u["CategoryID"], u["Name"], u["Description"]);
  //     cates.add(cate);
  //   }
  //   print(cates.length);
  //   return cates;
  // }
  Map<String, bool> values = {
    'foo': true,
    'bar': false,
  };
  final notifications = [];
  @override
  Widget build(BuildContext context) {
    final choosecate = [];
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Categories",
            style: TextStyle(fontSize: 25),
          ),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Category').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView(
                  children: snapshot.data!.docs.map((category) {
                var index = snapshot.data!.docs.indexOf(category);
                return buildSingleCheckbox(
                    CheckboxState(title: category['Name']));
              }).toList());
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.save),
      ),
    );
  }
}

Widget buildSingleCheckbox(CheckboxState checkbox) => CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Colors.red,
      value: checkbox.value,
      title: Text(checkbox.title),
      onChanged: (value) {
        setState() {
          checkbox.value = !checkbox.value;
        }
      },
    );

class CheckboxState {
  final String title;
  bool value;
  CheckboxState({
    required this.title,
    this.value = false,
  });
}

class Cate {
  final int CategoryID;
  final String Name;
  final String Description;
  Cate(this.CategoryID, this.Name, this.Description);
}
 // child: Text(
      //   "Select a few categories to get started",
      //   style: TextStyle(fontSize: 18),
      // ),
      // child: FutureBuilder(
      //   future: _getCates(),
      //   builder: (BuildContext context, AsyncSnapshot snapshot) {
      //     if (snapshot.hasData) {
      //       return ListView.builder(
      //         itemCount: snapshot.data.length,
      //         itemBuilder: (BuildContext context, int index) {
      //           return CheckboxListTile(
      //             controlAffinity: ListTileControlAffinity.leading,
      //             activeColor: Colors.red,
      //             value: value,
      //             title: Text(snapshot.data[index].Name),
      //             onChanged: (value) => setState(() => this.value = value!),
      //             onTap: () {
      //               Navigator.push(
      //                   context,
      //                   new MaterialPageRoute(
      //                       builder: (context) =>
      //                           Detail_Cate(snapshot.data[index])));
      //             },
      //           );
      //         },
      //       );
      //     } else {
      //       return CircularProgressIndicator();
      //     }
      //   },
      // )),