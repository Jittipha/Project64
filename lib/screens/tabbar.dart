// ignore: unused_import
// ignore_for_file: prefer_const_constructors, unused_field

import 'package:flutter/material.dart';
import 'package:project/Notification/views/HomeNotification.dart';
import 'package:project/algolia/searchpage.dart';
import 'package:project/screens/mainpage.dart';
import 'Home_Feed/homepage.dart';
import 'mainpage.dart';

class Tabbar extends StatefulWidget {
  const Tabbar({Key? key}) : super(key: key);

  @override
  _TabbarState createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> {
  String body = "Home";
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black);
  // ignore: prefer_final_fields
  static List<Widget> _widgetOptions = <Widget>[
    Homefeed(),
    SearchBar(),
    HomeNotification(),
    // Text(
    //   'Index 2:Notification',
    //   style: optionStyle,
    // ),
    MainPage(),
    
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('BottomNavigationBar Sample'),
      // ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
           //backgroundColor: Color(0xFF00BF6D),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
            //backgroundColor: Color(0xFF00BF6D),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
            //backgroundColor: Color(0xFF00BF6D),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
            //backgroundColor: Color(0xFF00BF6D),
          ),
          
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Color(0xFF00BF6D),
        selectedItemColor: Colors.black,
        backgroundColor: Color(0xFF00BF6D),
        
        onTap: _onItemTapped,
      ),
    );
  }
}
