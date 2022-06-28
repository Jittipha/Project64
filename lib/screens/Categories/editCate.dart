import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class editcate extends StatefulWidget {
  const editcate({Key? key}) : super(key: key);

  @override
  State<editcate> createState() => _editcateState();
}

class _editcateState extends State<editcate> {
  List Cate_id = [];
  List Listchoosed = [];
  String? text;
  List listshow = [];
  int length = 0;
  String id = "";
  String stringcheck = "2";
  @override
  void initState() {
    super.initState();
    addtolist();
    // cutlistshow();
  }

  Future addtolist() async {
    QuerySnapshot snap =
        await FirebaseFirestore.instance.collection("Category").get();
    List allData = snap.docs.map((doc) => doc.data()).toList();
    listshow = allData;

    QuerySnapshot snapforchoosed = await FirebaseFirestore.instance
        .collection("Student")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Categories")
        .get();
    List hasData = snapforchoosed.docs.map((doc) => doc.data()).toList();
    Listchoosed = hasData;
    print('listshow>>> $listshow');
    print('listchoosed >> $Listchoosed');
    for (int a = 0; a < Listchoosed.length; a++) {
      for (int z = listshow.length - 1; z >= 0; z--) {
        if (Listchoosed[a]['Name'] == listshow[z]['Name']) {
          listshow.removeAt(z);
        }
      }
    }
    setState(() {});
  }

  // Future cutlistshow() async {
  //   // for (int x = 0; x < Listchoosed.length; x++) {
  //   //   print(Listchoosed[x]);
  //   //   if (Listchoosed[x] == listshow[5]) {
  //   //     print("Yes");
  //   //   } else {
  //   //     print("No");
  //   //   }
  //   //   // for (int s = 0;s < listshow.length;s++) {}
  //   //   // if(){

  //   //   // }
  //   // }
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 30, 150, 140),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 13, 104, 96),
        title: const Text(
          "Edit your Categories",
          style: TextStyle(
            letterSpacing: 1,
            fontSize: 20,
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () async {
              if (Listchoosed.isNotEmpty) {
                QuerySnapshot delete = await FirebaseFirestore.instance
                    .collection('Student')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('Categories')
                    .get();
                delete.docs.forEach((element) async {
                  await FirebaseFirestore.instance
                      .collection('Student')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('Categories')
                      .doc(element.id)
                      .delete();
                });
                for (int a = 0; a < Listchoosed.length; a++) {
                  QuerySnapshot snaps = await FirebaseFirestore.instance
                      .collection("Category")
                      .where('Name', isEqualTo: Listchoosed[a]['Name'])
                      .where('Description',
                          isEqualTo: Listchoosed[a]['Description'])
                      .get();
                  snaps.docs.forEach((element) {
                    id = element.id;
                  });
                  FirebaseFirestore.instance
                      .collection('Student')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('Categories')
                      .doc()
                      .set({
                    "Description": Listchoosed[a]['Description'],
                    "Name": Listchoosed[a]['Name'],
                    "Category_id": id,
                    'Image': Listchoosed[a]['Image']
                  });
                }

                Fluttertoast.showToast(
                    msg: "Edit Success!", gravity: ToastGravity.CENTER);
                Navigator.pop(context);
              } else {
                showAlertDialog(
                    context,
                    text =
                        "กรุณาเลือกความน่าสนใจของหมวดหมู่ อย่างน้อย 1 หมวดหมู่");
              }
            },
            child: const Text(
              "NEXT",
              style: TextStyle(
                letterSpacing: 1,
                fontSize: 10,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w900,
              ),
            ),
            shape:
                const CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body: Container(
          child: Listchoosed.length == 0
              ? Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: const Text(
                        "แตะเพื่อเลือกความน่าสนใจของกิจกรรม",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      height: MediaQuery.of(context).size.height * 0.765,
                      child: ListView.builder(
                          itemCount: listshow.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.blueGrey[100],
                                child: CircleAvatar(
                                  radius: 23,
                                  backgroundImage:
                                      NetworkImage(listshow[index]['Image']),
                                ),
                              ),
                              title: Text(
                                listshow[index]['Name'].toString(),
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                listshow[index]["Description"].toString(),
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                                maxLines: 1,
                              ),
                              onTap: () {
                                setState(() {
                                  Listchoosed.add(listshow[index]);
                                  listshow.remove(listshow[index]);
                                });
                              },
                            );
                          }),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: const Text(
                        "แตะเพื่อเลือกความน่าสนใจของกิจกรรม",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      height: MediaQuery.of(context).size.height * 0.60,
                      child: ListView.builder(
                          itemCount: listshow.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.blueGrey[100],
                                child: CircleAvatar(
                                  radius: 23,
                                  backgroundImage:
                                      NetworkImage(listshow[index]['Image']),
                                ),
                              ),
                              title: Text(
                                listshow[index]['Name'].toString(),
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                listshow[index]["Description"].toString(),
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                                maxLines: 1,
                              ),
                              onTap: () {
                                if (Listchoosed.length == 3) {
                                  text = "จำกัดหมวดหมู่แค่ 3 หมวดหมู่";
                                  showAlertDialog(context, text);
                                } else {
                                  if (stringcheck == "2") {
                                    setState(() {
                                      Listchoosed.add(listshow[index]);
                                      listshow.remove(listshow[index]);
                                    });
                                  }
                                }
                                setState(() {
                                  stringcheck = "2";
                                });
                              },
                            );
                          }),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              top:
                                  BorderSide(color: Colors.black, width: 0.4))),
                      child: Column(
                        children: [
                          Container(
                            height: 30,
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                            child: const Text(
                              "Selected",
                              style: TextStyle(
                                letterSpacing: 1,
                                fontSize: 17,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                            height: MediaQuery.of(context).size.height * 0.13,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: Listchoosed.length,
                                itemBuilder: (BuildContext context, int index) {
                                  if (Listchoosed.isEmpty) {
                                    return const Center(
                                      child: Text("NOTHING"),
                                    );
                                  } else {
                                    return SizedBox(
                                        height: 100,
                                        width: 90,
                                        child: Column(children: [
                                          ListTile(
                                            leading: CircleAvatar(
                                              radius: 27,
                                              backgroundColor:
                                                  Colors.greenAccent[100],
                                              child: CircleAvatar(
                                                  radius: 25,
                                                  backgroundImage: NetworkImage(
                                                      Listchoosed[index]
                                                          ['Image']),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        listshow.add(
                                                            Listchoosed[index]);
                                                        Listchoosed.remove(
                                                            Listchoosed[index]);
                                                      });
                                                    },
                                                    child: const Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: CircleAvatar(
                                                        radius: 13,
                                                        child: Icon(
                                                          Icons.close_rounded,
                                                          size: 15,
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            Listchoosed[index]['Name']
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Raleway',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ]));
                                  }
                                }),
                          ),
                        ],
                      ),
                    )
                  ],
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
