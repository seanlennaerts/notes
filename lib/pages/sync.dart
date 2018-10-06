import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:notes/utils/server.dart' as util;

class Sync extends StatefulWidget {
  @override
  _SyncState createState() => _SyncState();
}

class _SyncState extends State<Sync> {
  String address;
  HttpServer server;

  @override
  void initState() {
    super.initState();
    address = 'Wi-Fi not connected';
    _initServer();
  }

  Future<void> _initServer() async {
    InternetAddress address = await util.getIpAddress();
    final HttpServer server = await HttpServer.bind(address, 80);
    setState(() {
      this.address = '${address.address}';
      this.server = server;
    });
    await for (HttpRequest request in server) {
      request.response.write('TODO');
      request.response.close();
    }
  }

  Future<bool> _onWillPop() async {
    server.close();
    return true;
  }

  buildActivityFlex() {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return Expanded(
        child: Container(),
        flex: 2,
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Wi-Fi Sync'),
          elevation: 0.0,
        ),
        body: Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                  color: Theme.of(context).primaryColor,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.wifi,
                          size: 125.0,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Text(
                          'Enter the following URL in your browser address bar',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Theme.of(context).primaryColorLight),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          'http://$address',
                          style: Theme.of(context)
                              .primaryTextTheme
                              .display1
                              .apply(color: Colors.white),
                        ),
                      ])),
              flex: 3,
            ),
            buildActivityFlex()
          ],
        ))
    );
    
  }
}
