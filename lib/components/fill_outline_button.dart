// import 'package:flutter/material.dart';
// import 'package:project/chooseCate.dart';
// import 'package:project/screens/Home_Feed/homepage.dart';
// import 'package:project/screens/Home_Feed/thisweek.dart';
// import 'package:project/screens/Home_Feed/today.dart';
// import 'package:project/screens/Home_Feed/tomorrow.dart';
// import 'package:project/screens/listcate.dart';

// class FillOutlineButton extends StatelessWidget {
//   const FillOutlineButton({
//     Key? key,
//     this.isFilled = true,
//     required this.press,
//     required this.text,
//     required this.Num,
//   }) : super(key: key);
//   static const List<Widget> _Goto = <Widget>[
//     Home(),
//     Today(),
//     Tomorrow(),
//     Thisweek(),
//   ];
//   final bool isFilled;
//   final VoidCallback press;
//   final String text;
//   // ignore: non_constant_identifier_names
//   final int Num;

//   @override
//   Widget build(BuildContext context) {
//     return MaterialButton(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(30),
//         side: const BorderSide(color: Colors.white),
//       ),
//       elevation: isFilled ? 2 : 0,
//       color: isFilled ? Colors.white : Colors.transparent,
//       onPressed: () {
//         Navigator.pop(
//             context, MaterialPageRoute(builder: (context) => Listcate()));
//       },
//       child: Text(
//         text,
//         style: TextStyle(
//           color: isFilled ? const Color(0xFF1D1D35) : Colors.white,
//           fontSize: 12,
//         ),
//       ),
//     );
//   }
// }
