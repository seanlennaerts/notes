import 'package:flutter/material.dart';
import 'dart:io';

import 'package:notes/pages/sync.dart';
import 'package:notes/pages/edit.dart';
import 'package:notes/pages/settings.dart';

import 'package:notes/components/slidable_tile.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:notes/app_state_container.dart';
import 'package:notes/models/app_state.dart';

class Notes extends StatefulWidget {
  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final SlidableController slidableController = SlidableController();
  final searchController = TextEditingController();

  bool search;
  bool clear;

  AppState appState;

  @override
    void initState() {
      super.initState();
      search = false;
      clear = false;
      searchController.addListener(_searchInputListener);
    }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _searchInputListener() {
    setState(() => clear = searchController.text.length > 0);
  }

  AppBar buildAppBar() {
    if (!search) {
      return AppBar(
        title: Text('Notes'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => setState(() => search = true), 
          )
        ]
      );
    } else {
      return AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        iconTheme: Theme.of(context).iconTheme,
        brightness: appState.darkMode ? Brightness.dark : Brightness.light,
        // titleSpacing: 0.0,
        leading: IconButton(
          icon: Platform.isIOS ? Icon(Icons.arrow_back_ios) : Icon(Icons.arrow_back),
          onPressed: () => setState(() => search = false),
        ),
        title: Container( // need to wrap in opaque background to remove ripple inkwell effect of textfield
          color: Theme.of(context).canvasColor,
          child: TextField(
            controller: searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search',
              border: InputBorder.none,
            ),

            
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            disabledColor: Theme.of(context).canvasColor,
            onPressed: clear ? () => searchController.clear() : null,
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);
    appState = container.state;

    return Scaffold(
      appBar: buildAppBar(),
      drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: <Widget>[
        DrawerHeader(
          child: Text(''),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
        ),
        ListTile(
            leading: Icon(Icons.wifi),
            title: Text(
              'Wi-Fi Sync',
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) {
                  return Sync();
                },
                fullscreenDialog: true,
              ));
            }),
        Divider(),
        ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) {
                  return Settings();
                },
                fullscreenDialog: true,
              ));
            })
      ])),
      body: ListView(
              children: List.generate(20, (index) {
        return SlidableTile(
          title: 'Note $index',
          subtitle:
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
          controller: slidableController,
        );
      })),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.create),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) {
                  return Edit();
                },
                fullscreenDialog: true,
              ));
        },
      ),
    );
  }
}
