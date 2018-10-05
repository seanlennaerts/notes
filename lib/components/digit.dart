import 'package:flutter/material.dart';

class Digit extends StatelessWidget {
  Digit({this.number});

  final String number;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue,
        ),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child:Center(
          child: Text(number, style: TextStyle(color: Colors.white),)
        )));
  }
}
