import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SlideDots extends StatelessWidget {
  bool isActive;
  SlideDots(this.isActive);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      margin: const EdgeInsets.symmetric(horizontal: 0),
      height: 10,
      width:  45,
      decoration: BoxDecoration(
        color: isActive ? Colors.cyan : Colors.blueGrey,
        border: isActive ?  Border.all(color: Color(0xff927DFF),width: 0.0,) : Border.all(color: Colors.transparent,width: 0,),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
  }
}