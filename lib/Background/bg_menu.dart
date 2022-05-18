import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // ignore: sized_box_for_whitespace
    return Container(
      height: size.height,
      width: double.infinity,
      decoration: const BoxDecoration(color:Color.fromARGB(255, 30, 150, 140 )),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: -450,
            child: Image.asset("assets/images/bg_menu.png"),
          ),
          child
        ],
      ),
    );
  }
}