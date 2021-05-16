import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:noor/constants/categories.dart';
import 'package:noor/constants/ribbons.dart';
import 'package:noor/models/doaa.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBService with ChangeNotifier {
  DBService._();
  static final DBService db = DBService._();

  static Database? _database;

  final String tableName = 'MyAd3yah';

  Future<Database?> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    return await initDB();
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'NoorDB.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE $tableName ('
          'id INTEGER PRIMARY KEY,'
          'text TEXT,'
          'info TEXT,'
          'section INTEGER,'
          'sectionName TEXT,'
          'isFav INTEGER'
          ');',
        );
      },
    );
  }

  Future<void> swap(Doaa from, Doaa to) async {
    final Database? db = await database;
    final String fromID = from.id;
    final String toID = to.id;
    final Map<String, dynamic> _from = from.toMap();
    final Map<String, dynamic> _to = to.toMap();

    _from['id'] = toID;
    _to['id'] = fromID;

    await db?.update(
      tableName,
      _from,
      where: 'id = ?',
      whereArgs: <String>[_from['id']],
    );
    await db?.update(
      tableName,
      _to,
      where: 'id = ?',
      whereArgs: <String>[_to['id']],
    );
  }

  Future<List<Doaa>> get() async {
    final Database? db = await database;
    final List<Map<String, Object?>> res =
        (await db?.query(tableName, orderBy: 'id')) ?? <Map<String, Object>>[];
    final List<Doaa> list = res.isNotEmpty
        ? res
            .map((Map<String, Object?> e) {
              final Map<String, dynamic> map = <String, dynamic>{
                'id': e['id'].toString(),
                'text': e['text'],
                'info': e['info'],
                'ribbon': Ribbon.ribbon5,
                'category': NoorCategory.MYAD3YAH,
                'sectionName': 'أدعيتي',
                'isFav': e['isFav'] == 1 ? true : false,
              };

              return Doaa.fromMap(map);
            })
            .toList()
            .cast<Doaa>()
        : <Doaa>[];
    return list;
  }

  insert(Doaa doaa) async {
    final Database? db = await database;
    await db?.insert(tableName, doaa.toMap());
  }

  update(Doaa doaa) async {
    final Database? db = await database;
    await db?.update(
      tableName,
      doaa.toMap(),
      where: 'id = ?',
      whereArgs: <String>[doaa.id],
    );
  }

  delete(Doaa doaa) async {
    final Database db = await (database as FutureOr<Database>);
    db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: <String>[doaa.id],
    );
  }
}
