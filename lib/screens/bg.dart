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
      decoration: BoxDecoration(color: Colors.green[100]),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset("assets/images/cir_green.png"),
          ),
          Positioned(
            bottom: 0,
            right: 0,
           child: Image.asset("assets/images/cir_green.png"),
          ),
          child
        ],
      ),
    );
  }
}