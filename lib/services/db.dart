import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:noor/models/doaa.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBService with ChangeNotifier {
  DBService._();
  static final DBService db = DBService._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    return await initDB();
  }

  Map<int, String> scripts = {
    1: 'CREATE TABLE MyAd3yah ('
        'id INTEGER PRIMARY KEY,'
        'text TEXT,'
        'info TEXT,'
        'section INTEGER,'
        'sectionName TEXT,'
        'isFav INTEGER'
        ');',
    2: 'INSERT INTO Ad3yah(id, text, info, isFav) SELECT id, content, additionalContent, isFav FROM Client WHERE section = ?',
    3: 'DROP TABLE Client',
  };

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'NoorDB.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (Database db, int version) async {
        await db.execute(scripts[1]);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {
          //running all scripts [including delete] if the db exists
          await db.execute('CREATE TABLE MyAd3yah ('
              'id INTEGER PRIMARY KEY,'
              'text TEXT,'
              'info TEXT,'
              'section INTEGER,'
              'sectionName TEXT,'
              'isFav INTEGER'
              ');');
          await db.execute(
              'INSERT INTO MyAd3yah(id, text, info, isFav) SELECT id, content, additionalContent, isFav FROM Client WHERE family = ?',
              [5]);
          await db.execute('DROP TABLE Client');
        }
      },
    );
  }

  Future<void> swap(Doaa from, Doaa to) async {
    final Database db = await database;
    final String fromID = from.id;
    final String toID = to.id;
    final Map<String, dynamic> _from = from.toMap();
    final Map<String, dynamic> _to = to.toMap();

    _from['id'] = toID;
    _to['id'] = fromID;

    await db.update('MyAd3yah', _from, where: 'id = ?', whereArgs: <dynamic>[_from['id']]);
    await db.update('MyAd3yah', _to, where: 'id = ?', whereArgs: <dynamic>[_to['id']]);
  }

  Future<List<Doaa>> get() async {
    final Database db = await database;
    final List<Map<String, Object>> res = await db.query('MyAd3yah', orderBy: 'id');
    final List<Doaa> list = res.isNotEmpty ? res.map((Map<String, Object> e) => Doaa.fromMap(e, sectionName: 'أدعيتي', section: 5)).toList().cast<Doaa>() : <Doaa>[];
    return list;
  }

  insert(Doaa newClient) async {
    final Database db = await database;
    var res = await db.insert('MyAd3yah', newClient.toMap());
    return res;
  }

  update(Doaa newClient) async {
    final Database db = await database;
    var res = await db.update('MyAd3yah', newClient.toMap(), where: 'id = ?', whereArgs: [newClient.id]);
    return res;
  }

  delete(Doaa doaa) async {
    final Database db = await database;
    db.delete('MyAd3yah', where: 'id = ?', whereArgs: [doaa.id]);
  }
}
