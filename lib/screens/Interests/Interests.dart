import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:project/Model/Event.dart';
import 'package:project/chooseCate.dart';
import 'package:project/screens/DetailCate.dart';
import 'package:project/Model/Category.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/screens/postcategorise.dart';
import 'package:project/screens/tabbar.dart';

class Postinterests extends StatefulWidget {
  QueryDocumentSnapshot<Object?> documents;
  Postinterests(this.documents);
  @override
  _Postinterests createState() => _Postinterests();
}

class _Postinterests extends State<Postinterests> {
  final String test = "Fuck";
  final _formKey = GlobalKey<FormState>();
  final Cate_id = [];
  final Cate_name = [];
  final Cate_Description = [];
  var Choose;
  Cates cates = Cates();
  events event = events();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Interests",
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: Container(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Category')
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return ListView(
                          children: snapshot.data!.docs.map((category) {
                        Cate_name.add(category["Name"]);
                        Cate_id.add(category.id);
                        Cate_Description.add(category["Description"]);
                        return Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                              border: Border(
                            top: BorderSide(
                                width: 0.5, color: Color(0xFF7F7F7F)),
                            right: BorderSide(
                                width: 1.0, color: Color(0xFF7F7F7F)),
                            bottom: BorderSide(
                                width: 0.5, color: Color(0xFF7F7F7F)),
                          )),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text(category["Num"]),
                              backgroundColor: Colors.orange[300],
                            ),
                            title: Text(
                              category["Name"],
                              style: const TextStyle(fontSize: 16),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Detail_Cate(category: category)));
                            },
                          ),
                        );
                      }).toList());
                    }
                  }),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              padding: const EdgeInsets.all(8.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const Padding(padding: EdgeInsets.fromLTRB(0, 240, 0, 0)),
                      const Text(
                        "ป้อนหมายเลขความสนใจของกิจกรรม",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                      TextFormField(
                        decoration: const InputDecoration(
                          label: Text('เช่น 1,2,3,...'),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(),
                        validator: RequiredValidator(errorText: "กรุณาใส่เลข!"),
                        onSaved: (value) {
                          Choose = value.toString();
                        },
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              var arraychoose = Choose.split(",");
              print(arraychoose);

              for (int a = 0; a < arraychoose.length; a++) {
                print(arraychoose[a]);
                int x = int.parse(arraychoose[a]);
                print(x);
                print(Cate_name[x - 1]);
                FirebaseFirestore.instance
                    .collection('Event')
                    .doc(widget.documents.id)
                    // .collection('Interests')
                    // .doc()
                    .set({
                  "Interests": [
                    Cate_id[x - 1],
                  ]
                });
                QuerySnapshot snap = await FirebaseFirestore.instance
                    .collection('Student')
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .collection('Posts')
                    .where("Name", isEqualTo: event.Name)
                    .where("Event_id", isEqualTo: widget.documents.id)
                    .get();
                snap.docs.forEach((document) async {
                  FirebaseFirestore.instance
                      .collection('Student')
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .collection('Posts')
                      .doc(document.id)
                      // .collection('Interests')
                      // .doc()
                      .set({
                    "Interests": [Cate_id[x - 1]]
                  }).then((value) => {
                            Fluttertoast.showToast(
                                msg: "Success!", gravity: ToastGravity.CENTER),
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return const Tabbar();
                              },
                            ))
                          });
                });
              }
            }
          },
          child: const Icon(Icons.check_circle_outline_outlined)),
    );
  }
}
