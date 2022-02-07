// ignore_for_file: unnecessary_const, curly_braces_in_flow_control_structures, unnecessary_new, non_constant_identifier_names, use_key_in_widget_constructors, must_be_immutable, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, await_only_futures, deprecated_member_use, prefer_is_empty, prefer_final_fields, unused_field, unused_element, unrelated_type_equality_checks


import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
// import 'package:project/algolia/AlgoliaApplication.dart';
// import 'package:project/algolia/AlgoliaApplication.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _searchText = TextEditingController(text: "");
  List<AlgoliaObjectSnapshot> _results = [];
  bool _searching = false;

  _search() async {
    setState(() {
      _searching = true;
    });

    Algolia algolia = Algolia.init(
      applicationId: 'ZO4XKCM05Q',
      apiKey: 'b57d151dcd4821d1df6a23485e70ec2d',
    );

    AlgoliaQuery query = algolia.instance.index('Event');
    query = query.search(_searchText.text);

    _results = (await query.getObjects()).hits;

    setState(() {
      _searching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Algolia Search"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Search"),
            TextField(
              controller: _searchText,
              decoration: InputDecoration(hintText: "Search query here..."),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  color: Colors.blue,
                  child: Text(
                    "Search",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: _search,
                ),
              ],
            ),
            Expanded(
              child: _searching == true
                  ? Center(
                      child: Text("Searching, please wait..."),
                    )
                  : _results.length == 0
                      ? Center(
                          child: Text("No results found."),
                        )
                      : ListView.builder(
                          itemCount: _results.length,
                          itemBuilder: (BuildContext ctx, int index) {
                            AlgoliaObjectSnapshot snap = _results[index];

                            return ListTile(
                              leading: CircleAvatar(
                                child: Text(
                                  (index + 1).toString(),
                                ),
                              ),
                              title: Text(snap.data["Name"]),
                              subtitle: Text(snap.data["Description"]),
                            );
                          },
                        ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


// -------------------------------------------------------------------------------------------------------------


//  class _SearchBarState extends State<SearchBar> {

  
//   final Algolia _algoliaApp = AlgoliaApplication.algolia;
//   // String? _searchTerm;
//   bool _searching = false;
  

  // Future<List<AlgoliaObjectSnapshot>> _operation( _searching) async {
    // List<AlgoliaObjectSnapshot> _results = [];
    
    // AlgoliaQuery query = await _algoliaApp.instance.index('Event');
    // query = await query.search(_searchTerm);

    // AlgoliaQuery query = _algoliaApp.instance.index('Event');
    // query = query.search(_searching.text);

    // _results = (await query.getObjects()).hits;

    // setState(() {
    //   _searching = false;
    // });
  // }

    // AlgoliaQuerySnapshot querySnap = await query.getObjects();
    // List<AlgoliaObjectSnapshot> results = querySnap.hits;
    // return results;
  // }

//   class _SearchBarState extends State<SearchBar> {
//   final TextEditingController _searchText = TextEditingController(text: "");
//   List<AlgoliaObjectSnapshot> _results = [];
//   bool _searching = false;

//   _search() async {
//     setState(() {
//       _searching = true;
//     });

//     Algolia algolia = Algolia.init(
//       applicationId: 'ZO4XKCM05Q',
//       apiKey: 'b57d151dcd4821d1df6a23485e70ec2d',
//     );

//     AlgoliaQuery query = algolia.instance.index('Event');
//     query = query.search(_searchText.text);

//     _results = (await query.getObjects()).hits;

//     setState(() {
//       _searching = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             " Algolia",
//             style: TextStyle(color: Colors.black),
//           ),
//         ),
//         body: SingleChildScrollView(
//           child: Column(children: <Widget>[
//             TextField(
//                 onChanged:(_search)async{
//                   setState(() {
//                     _search;
//                   });
//                 },
//                 style: const TextStyle(color: Colors.black, fontSize: 20),
//                 decoration: const InputDecoration(
//                     border: InputBorder.none,
//                     hintText: 'Search',
//                     hintStyle: const TextStyle(color: Colors.black),
//                     prefixIcon: const Icon(Icons.search, color: Colors.black))),
//             StreamBuilder<List<AlgoliaObjectSnapshot>>(
//               // stream: Stream.fromFuture((_searchTerm)),
//               builder: (context, snapshot) {
//                 if (snapshot.hasData)
//                   return const Text(
//                     "Start Typing",
//                     style: TextStyle(color: Colors.black),
//                   );
//                 else {
//                   List<AlgoliaObjectSnapshot>? _results = snapshot.data;

//                   switch (snapshot.connectionState) {
//                     case ConnectionState.waiting:
//                       return Container();
//                     default:
//                       if (snapshot.hasError)
//                         return new Text('Error: ${snapshot.error}');
//                       else
//                         return CustomScrollView(
//                           shrinkWrap: true,
//                           slivers: <Widget>[
//                             SliverList(
//                               delegate: SliverChildBuilderDelegate(
//                                 (context, index) {
//                                   return _results!.length == 0 ?
//                                 //  _results!.length == 0 {
//                                      DisplaySearchResult(
//                                           Description: _results[index]
//                                               .data["Description"],
//                                           Name: _results[index]
//                                               .data["Name"],
//                                           interests: _results[index]
//                                               .data["interests"],
//                                         ) :
//                               Container();
                                  
//                                 },
//                               ),
//                             ),
//                           ],
//                         );
//                   }
//                 }
//               },
//             ),
//           ]),
//         ),
//       ),
//     );
//   }
// }

// class DisplaySearchResult extends StatelessWidget {
//    String? Description;
//    String? Name;
//    String? interests;

//   DisplaySearchResult( 
//   {Key? key, this.Description, this.Name, this.interests}) : super(key: key);
  

//   @override
//   Widget build(BuildContext context) {
//     return Column(children: <Widget>[
//       Text(
//         Description ?? "",
//         style: const TextStyle(color: Colors.black),
//       ),
//       Text(
//         Name ?? "",
//         style: const TextStyle(color: Colors.black),
//       ),
//       Text(
//         interests ?? "",
//         style: const TextStyle(color: Colors.black),
//       ),
//       const Divider(
//         color: Colors.black,
//       ),
//       const SizedBox(height: 20)
//     ]);
//   }
// }
