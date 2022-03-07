// ignore_for_file: file_names
// // ignore_for_file: file_names, avoid_print

// import 'package:flutter/material.dart';

// class SearchBar extends StatefulWidget {
//   const SearchBar({
//     Key? key,
//   }) : super(key: key);

//   @override
//   _SearchBarState createState() => _SearchBarState();

//   // void onSearch(String text) {}
// }

// class _SearchBarState extends State<SearchBar> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Search'),
//         actions: [
//           Container(
//               margin: const EdgeInsets.all(5),
//               child: Search(
//                 onSearch: (text) {
//                   print(text);
//                 },
//               )),
//         ],
//       ),
//       // body: Column(
//       //   children: [
//       //     (Search(
//       //       onSearch: (text) {
//       //         print(text);
//       //       },
//       //     )),
//       //   ],
//       // ),
//     );
//   }
// }

// class Search extends StatefulWidget {
//   final Function(String) onSearch;
//   const Search({Key? key, required this.onSearch}) : super(key: key);

//   @override
//   _SearchState createState() => _SearchState();
// }

// class _SearchState extends State<Search> {
//   var expanded = false;
//   final width = 200.0;
//   final height = 50.0;
//   final controller = TextEditingController();
//   final focusNode = FocusNode();

//   @override
//   void dispose() {
//     controller.dispose();
//     focusNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 200),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(height / 2),
//         color: expanded ? Colors.black12 : Colors.transparent,
//       ),
//       width: expanded ? width : height,
//       height: height,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SizedBox(
//             width: height,
//             height: height,
//             child: IconButton(
          
//                 onPressed: () {
//                   setState(() {
//                     expanded = !expanded;
//                   });
//                 },
//                 icon: const Icon(Icons.search)),
//           ),
//           AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             width: expanded ? width - height - height / 2 : 0,
//             height: height,
//             child: TextField(
//               focusNode: focusNode,
//               controller: controller,
//               textInputAction: TextInputAction.search,
//               decoration: const InputDecoration(
//                 border: InputBorder.none,
//               ),
//               onEditingComplete: () {
//                 widget.onSearch(controller.text);
//                 controller.clear();
//                 setState(() {
//                   expanded = false;
//                 });
//               },
//             ),
//             onEnd: () {
//               if (expanded) {
//                 focusNode.requestFocus();
//               } else {
//                 focusNode.unfocus();
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
