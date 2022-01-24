import 'package:flutter/material.dart';

class AddCategorise extends StatelessWidget {
  const AddCategorise({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Categorise",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
    );
  }
}
