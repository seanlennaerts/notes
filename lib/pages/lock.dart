import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:notes/components/digit.dart';

class Lock extends StatefulWidget {
  @override
  _LockState createState() => _LockState();
}

class _LockState extends State<Lock> {
  @override
  void initState() {
    super.initState();
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  Widget buildDigit(BuildContext context, int n) {
    // return SizedBox(
    //   width: MediaQuery.of(context).size.width / 5,
    //   height: MediaQuery.of(context).size.width / 5,
    //   child: Digit(number: n.toString()),
    // );
    return FittedBox(
      child: Digit(number: n.toString()),
      fit: BoxFit.cover,
    );

    // return ConstrainedBox(
    //   constraints: BoxConstraints(
    //     minWidth: 100.0,
    //     minHeight: 100.0,
    //   ),
    //   child: Digit(number:n.toString()),

    // );
    // return Digit(number: n.toString());
  }

  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarBrightness: Brightness.dark));

    return Scaffold(
        body: Flex(
      direction: Axis.vertical,
      children: [
        Expanded(
            child: Container(
              color: Colors.blue,
            ),
            flex: 1),
        Expanded(
          child: Container(
              padding: EdgeInsets.all(40.0),
              color: ThemeData(primarySwatch: Colors.blue).canvasColor,
              child: GridView.count(
                crossAxisCount: 3,
                physics: NeverScrollableScrollPhysics(),
                mainAxisSpacing: 30.0,
                crossAxisSpacing: 30.0,
                children: [
                  buildDigit(context, 1),
                  buildDigit(context, 2),
                  buildDigit(context, 3),
                  buildDigit(context, 4),
                  buildDigit(context, 5),
                  buildDigit(context, 6),
                  buildDigit(context, 7),
                  buildDigit(context, 8),
                  buildDigit(context, 9),
                  buildDigit(context, 0),
                ],
              )
              // child: Column(
              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //     children: [
              //       Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //           children: [
              //             buildDigit(context, 1),
              //             buildDigit(context, 2),
              //             buildDigit(context, 3),
              //           ]),
              //       Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //           children: [
              //             buildDigit(context, 4),
              //             buildDigit(context, 5),
              //             buildDigit(context, 6),
              //           ]),
              //       Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //           children: [
              //             buildDigit(context, 7),
              //             buildDigit(context, 8),
              //             buildDigit(context, 9),
              //           ]),
              //       Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //           children: [
              //             buildDigit(context, 0),
              //           ]),
              //     ]),
              ),
          flex: 3,
        )
      ],
    ));
  }
}
