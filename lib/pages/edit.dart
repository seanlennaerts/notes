import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';

import 'package:notes/app_state_container.dart';
import 'package:notes/models/app_state.dart';

import 'package:zefyr/zefyr.dart';

import 'package:notes/models/note.dart';

class Edit extends StatefulWidget {
  Edit({this.note});

  final Note note;

  @override
  _EditState createState() => _EditState();
}

enum Mode { New, View }

class _EditState extends State<Edit> {
  ZefyrController _controller;
  FocusNode _focusNode;
  bool _editing;
  NotusDocument _doc;
  AppState appState;
  Mode mode;

  @override
  void initState() {
    super.initState();

    if (widget.note == null) {
      _doc = NotusDocument();
      mode = Mode.New;
      _editing = true;
    } else {
      _doc = NotusDocument.fromJson(jsonDecode(widget.note.doc));
      mode = Mode.View;
      _editing = false;
    }

    _controller = ZefyrController(_doc);
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  _saveFile() {
    String plain = _doc.toPlainText();
    String plainStripped = plain.replaceAll('\n', ' ').trim();

    if (plainStripped.length > 0) {
      switch (mode) {
        case Mode.New:
          Note n = Note(
              id: DateTime.now().millisecondsSinceEpoch,
              title: plain.split('\n')[0].trim(),
              doc: jsonEncode(_doc.toJson()),
              plainText: plainStripped,
              timeStamp: DateTime.now());
          appState.db.saveNote(n);
          break;
        case Mode.View:
          Note n = Note(
              id: widget.note.id,
              title: plain.split('\n')[0].trim(),
              doc: jsonEncode(_doc.toJson()),
              plainText: plainStripped,
              timeStamp: DateTime.now());
          appState.db.updateNote(n);
          break;
      }
    }
  }

  Future<bool> _onWillPop() async {
    setState(() => _editing = false);
    _saveFile();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);
    appState = container.state;
    // ModalRoute.of(context).didPush().then((v) {
    //   print('done');
    // });
    final themeTextColor = Theme.of(context).textTheme.body1.color;
    final HeadingTheme htf = HeadingTheme.fallback();
    final BlockTheme btf = BlockTheme.fallback();

    final theme = new ZefyrThemeData(
      toolbarTheme: ZefyrToolbarTheme.fallback(context).copyWith(
        color: Colors.grey[200],
        toggleColor: Colors.grey[400],
        iconColor: Colors.grey[800],
        disabledIconColor: Colors.grey[400],
      ),
      paragraphTheme: StyleTheme(
          textStyle: TextStyle(
            fontSize: 16.0,
            height: 1.25,
            fontWeight: FontWeight.normal,
            color: themeTextColor,
          ),
          padding: ZefyrThemeData.fallback(context).paragraphTheme.padding),
      linkStyle: TextStyle(
        color: Theme.of(context).accentColor,
        decoration: TextDecoration.underline,
      ),
      headingTheme: HeadingTheme(
          level1: StyleTheme(
              textStyle: htf.level1.textStyle
                  .merge(TextStyle(color: themeTextColor, inherit: true)),
              padding: htf.level1.padding),
          level2: StyleTheme(
              textStyle: htf.level2.textStyle
                  .merge(TextStyle(color: themeTextColor, inherit: true)),
              padding: htf.level2.padding),
          level3: StyleTheme(
              textStyle: htf.level3.textStyle
                  .merge(TextStyle(color: themeTextColor, inherit: true)),
              padding: htf.level3.padding)),
      blockTheme: BlockTheme(
          bulletList: btf.bulletList,
          numberList: btf.numberList,
          quote: StyleTheme(
            textStyle:
                TextStyle(color: Theme.of(context).textTheme.caption.color),
            padding: btf.quote.padding,
          ),
          code: btf.code),
      selectionColor: Theme.of(context).textSelectionColor,
    );

    if (_editing) {
      FocusScope.of(context).requestFocus(_focusNode);
    }

    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            appBar: AppBar(
              brightness:
                  appState.darkMode ? Brightness.dark : Brightness.light,
              elevation: 0.0,
              backgroundColor: Theme.of(context).canvasColor,
              iconTheme: IconThemeData(color: Theme.of(context).accentColor),
              actions: [
                _editing
                    ? GestureDetector(
                        child: Material(
                          child: Container(
                            // color: Colors.red,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 0.0),
                            child: Center(
                              child: Text(
                                'Done',
                                style: Theme.of(context).textTheme.button.apply(
                                    color: Theme.of(context).accentColor),
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() => _editing = false);
                          _saveFile();
                        }
                      )
                    : Container(),
              ],
            ),
            body: GestureDetector(
                onTap: () => setState(() => _editing = true),
                child: ZefyrTheme(
                    data: theme,
                    child: ZefyrEditor(
                      controller: _controller,
                      focusNode: _focusNode,
                      enabled: _editing,
                      autofocus: true,
                    )))));
  }
}
