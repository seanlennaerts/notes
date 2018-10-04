import 'package:flutter/material.dart';

import 'package:notes/app_state_container.dart';
import 'package:notes/models/app_state.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // bool _darkMode;
  bool _passcode;
  AppState appState;

  @override
    void initState() {
      super.initState();
      // _darkMode = false;
      _passcode = false;
    }
  
  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);
    appState = container.state;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Settings')
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Passcode'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Off'),
                Icon(Icons.chevron_right)
              ]
            )
          ),
          Divider(),
          ListTile(
            title: Text('Dark mode'),
            trailing: Switch(
              onChanged: (value) => container.setDarkMode(value),
              value: appState.darkMode,
            ),
          ),
        ]
      )
      
    );
  }
}