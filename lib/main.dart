import 'package:flutter/material.dart';
import 'package:notes/pages/notes.dart';
import 'package:notes/pages/lock.dart';

import 'package:notes/app_state_container.dart';
import 'package:notes/models/app_state.dart';

void main() => runApp(AppStateContainer(child: MyApp()));

class MyApp extends StatelessWidget {
  AppState appState;

  _handleAuthFlow() {
    return Notes();
  }

  @override
  Widget build(BuildContext context) {

    var container = AppStateContainer.of(context);
    appState = container.state;

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: appState.darkMode ? Brightness.dark : Brightness.light, 
        primarySwatch: Colors.blue,
      ),
      home: _handleAuthFlow(),
    );
  }
}
