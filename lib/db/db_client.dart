import 'dart:io';
import 'dart:core';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:what_am_i_doing_to/models/TaskModel.dart';

abstract class DB {

  static Database _db;

  static int get _version => 1;

  static Future<void> init() async {

    if (_db != null) { return; }

    try {
      String _path = await getDatabasesPath() + 'items_db';
      _db = await openDatabase(_path, version: _version, onCreate: onCreate);
    }
    catch(ex) {
      print(ex);
    }
  }

  static void onCreate(Database db, int version) async =>
      await db.execute('CREATE TABLE target_items (id INTEGER PRIMARY KEY NOT NULL, title STRING, steps_json STRING)');

  static Future<List<Map<String, dynamic>>> query() async => _db.query("target_items");

  static Future<int> insert( TaskModel model) async =>
      await _db.insert("target_items", model.toMap());

  static Future<int> update( TaskModel model) async =>
      await _db.update("target_items", model.toMap(), where: 'id = ?', whereArgs: [model.id]);

  static Future<int> delete( TaskModel model) async =>
      await _db.delete("target_items", where: 'id = ?', whereArgs: [model.id]);
}
