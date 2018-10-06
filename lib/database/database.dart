import 'package:sqflite/sqflite.dart';

import 'dart:async';
import 'package:path/path.dart';

import 'package:notes/models/note.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database _db;
  DatabaseHelper.internal();

  final String tableName = 'notes';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    print('initDatabase');
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, '$tableName.db');

    // await deleteDatabase(path); //for testing

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int newVersion) async {
    print('onCreate');
    await db.execute(
        'CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT, doc TEXT, plainText TEXT, timeStamp INTEGER)');
  }

  Future<int> saveNote(Note note) async {
    print('saveNote');

    var dbClient = await db;
    return await dbClient.rawInsert(
        'INSERT INTO notes(title, doc, plainText, timeStamp) VALUES (?, ?, ?, ?)',
        [
          note.title,
          note.doc,
          note.plainText,
          note.timeStamp.millisecondsSinceEpoch
        ]);
  }

  Future<List<Note>> getAllNotes() async {
    var dbClient = await db;
    var result = await dbClient
        .rawQuery('SELECT * FROM $tableName ORDER BY timeStamp DESC');
    return result.map((note) {
      return Note(
          id: note['id'],
          title: note['title'],
          doc: note['doc'],
          plainText: note['plainText'],
          timeStamp: DateTime.fromMillisecondsSinceEpoch(note['timeStamp']));
    }).toList();
  }

  Future<List<Note>> searchNotes(String keyword) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT * FROM $tableName WHERE plainText LIKE "%$keyword%" ORDER BY timestamp DESC');
    return result.map((note) {
      return Note(
          id: note['id'],
          title: note['title'],
          doc: note['doc'],
          plainText: note['plainText'],
          timeStamp: DateTime.fromMillisecondsSinceEpoch(note['timeStamp']));
    }).toList();
  }

  Future<Note> getNote(int id) async {
    print('getNote');

    var dbClient = await db;
    var result =
        await dbClient.rawQuery('SELECT * FROM $tableName WHERE id = $id');

    if (result.length == 1) {
      return Note(
          id: result[0]['id'],
          title: result[0]['title'],
          doc: result[0]['doc'],
          plainText: result[0]['plainText'],
          timeStamp: result[0]['timeStamp']);
    } else {
      print(
          'Couldnt find any notes with id $id or there was more than 1 note which is bad... see length ${result.length}');
      return null;
    }
  }

  Future<int> deleteNote(int id) async {
    print('deleteNote');

    var dbClient = await db;
    return await dbClient.rawDelete('DELETE FROM $tableName WHERE id = $id');
  }

  Future<int> updateNote(Note note) async {
    print('updateNote');

    var dbClient = await db;
    return await dbClient.rawUpdate(
        'UPDATE $tableName SET title = ?, doc = ?, plainText = ?, timeStamp = ? WHERE id = ?',
        [note.title, note.doc, note.plainText, note.timeStamp.millisecondsSinceEpoch, note.id]);
  }

  Future close() async {
    print('closing database');
    var dbClient = await db;
    return dbClient.close();
  }
}

// SQL commands
// CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT, doc TEXT, plainText TEXT, timeStamp INTEGER)

// INSERT INTO notes(title, doc, plainText, timeStamp) VALUES ('note 1', 'this is the doc', 'this is plaintext doc for searchability', 192038)

// SELECT * FROM [notes]
