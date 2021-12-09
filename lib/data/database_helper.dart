import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Future<Database> setDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    return await openDatabase(join(directory.path, 'tasks.db'),
        version: 1, onCreate: _onCreateDatabase);
  }

  _onCreateDatabase(Database database, int version) async {
    await database.execute(
        'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, content TEXT)');
    await database.execute(
        'CREATE TABLE todos(id INTEGER PRIMARY KEY, taskId INTEGER, title TEXT, isComplete TEXT)');
  }
}
