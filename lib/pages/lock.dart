import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:collection/collection.dart';
// import 'package:vibrate/vibrate.dart';

import 'package:notes/components/digit.dart';
import 'package:notes/components/dot.dart';
import 'package:notes/components/shake_animation_widget.dart';

class Lock extends StatefulWidget {
  @override
  _LockState createState() => _LockState();
}

class _LockState extends State<Lock> with SingleTickerProviderStateMixin {
  AnimationController controller;
  List<int> pin;

  @override
  void initState() {
    super.initState();
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setPreferredOrientations([
      // DeviceOrientation.landscapeLeft,
      // DeviceOrientation.landscapeRight,
      // DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    pin = [];
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    controller.dispose();
    super.dispose();
  }


  addToPin(int n) {
    if (pin.length < 4) {
      setState(() => pin.add(n));
    }
  }

  Widget buildDigit(int n) {
    return Padding(
      child: Digit(number: n.toString(), onTap: () => addToPin(n)),
      padding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 2.0),
    );
  }

  List<Dot> buildDots() {
    List<Dot> dots = [];
    for (int i = 0; i < 4; i++) {
      dots.add(Dot(filled: i < pin.length));
    }
    return dots;
  }

  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarBrightness: Brightness.dark));

    print(pin);

    final Color backgroundColor = Color(0xFFFDFEFF);

    final dots = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buildDots(),
    );

    final deleteButton = GestureDetector(
        child: Container(
            color: backgroundColor, //backgroundColor, // Colors.red,
            height: 32.0,
            width:
                25.0, // 22 on width + 10 on margin adds to 32.0, wanted to extend hitbox of delete butotn
            margin: EdgeInsets.fromLTRB(
                7.0, 0.0, 0.0, 0.0), // ...without showing up on 0's ink splash
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 4.0, 0.0),
            child: Icon(
              Icons.backspace,
              color: Colors.blue,
              size: 15.0,
            )),
        onTap: () => setState(() {
              if (pin.length > 0) {
                pin.removeLast();
              }
            }));

    final passCode = FittedBox(
        fit: BoxFit.contain,
        child: Column(children: [
          Row(children: [
            buildDigit(1),
            buildDigit(2),
            buildDigit(3),
          ]),
          Row(children: [
            buildDigit(4),
            buildDigit(5),
            buildDigit(6),
          ]),
          Row(children: [
            buildDigit(7),
            buildDigit(8),
            buildDigit(9),
          ]),
          Row(children: [
            SizedBox(
              width: 32.0,
            ),
            buildDigit(0),
            deleteButton,
          ]),
        ]));

    void checkPin() async {
      if (pin.length == 4 && !ListEquality().equals(pin, [1, 2, 3, 4])) {
        // Vibrate.feedback(FeedbackType.error);
        controller.reset();
        await controller.forward();
        setState(() => pin.clear());
      }
    }
    checkPin();



    return Scaffold(
        backgroundColor: backgroundColor,
        body: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
                child: Container(
                    color: Colors.blue,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text('Enter passcode',
                              style: TextStyle(color: Color(0xFFFDFEFF))),
                        ),
                        ShakeAnimationWidget(
                          child: dots,
                          controller: controller,
                        ),
                      ],
                    )),
                flex: 1),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(30.0),
                child: passCode,
              ),
              flex: 3,
            )
          ],
        ));
  }
}
