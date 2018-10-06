import 'package:flutter/material.dart';
import 'dart:io';

import 'package:notes/pages/sync.dart';
import 'package:notes/pages/edit.dart';
import 'package:notes/pages/settings.dart';

import 'package:notes/components/slidable_tile.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:notes/app_state_container.dart';
import 'package:notes/models/app_state.dart';
import 'package:notes/utils/pretty_date.dart' as prettyDate;

import 'package:notes/models/note.dart';

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
      return AppBar(title: Text('Notes'), actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () => setState(() => search = true),
        )
      ]);
    } else {
      return AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        iconTheme: Theme.of(context).iconTheme,
        brightness: appState.darkMode ? Brightness.dark : Brightness.light,
        // titleSpacing: 0.0,
        leading: IconButton(
          icon: Platform.isIOS
              ? Icon(Icons.arrow_back_ios)
              : Icon(Icons.arrow_back),
          onPressed: () {
            setState(() => search = false);
            searchController.clear();
          },
        ),
        title: Container(
          // need to wrap in opaque background to remove ripple inkwell effect of textfield
          color: Theme.of(context).canvasColor,
          child: TextField(
            controller: searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search',
              border: InputBorder.none,
            ),
            textInputAction: TextInputAction.search,
          ),
        ),
        actions: [
          clear
              ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: searchController.clear,
                )
              : Container()
        ],
      );
    }
  }

  String buildDescription(int titleLength, String plainText) {
    if (titleLength >= plainText.length) {
      return 'No additional text';
    }
    return plainText.substring(titleLength + 1);
  }

  List<SlidableTile> _buildNotes(AsyncSnapshot snapshot) {
    return (snapshot.data as List<Note>).map((Note note) {
      return SlidableTile(
          title: note.title,
          subtitle: buildDescription(note.title.length, note.plainText),
          date: prettyDate.prettify(note.timeStamp),
          controller: slidableController,
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) {
              return Edit(note: note); //TODO: should not hold whole note!, must call async get from database
            },
            fullscreenDialog: false));
          },
          onTapDelete: () => appState.db.deleteNote(note.id).then((v) => setState(() {})));
    }).toList();
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
          child: Text(''), //TODO:
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
      body: FutureBuilder(
          future: search ? appState.db.searchNotes(searchController.text) : appState.db.getAllNotes(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != null && snapshot.data.length > 0) {
                return ListView(children: _buildNotes(snapshot));
              } else {
                return Center(child: Text('No notes', style: TextStyle(color: Colors.grey)));
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
      // ListView(
      //     children: List.generate(20, (index) {
      //   return SlidableTile(
      //     title: 'Note $index',
      //     subtitle:
      //         'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      //     controller: slidableController,
      //   );
      // })),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.create),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) {
              return Edit();
            },
            fullscreenDialog: false,
          ));
        },
      ),
    );
  }
}
