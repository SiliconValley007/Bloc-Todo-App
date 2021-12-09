import 'package:sqflite/sqflite.dart';
import 'package:todo_app/data/database_helper.dart';

class Repository {
  late DatabaseHelper _databaseHelper;

  Repository() {
    _databaseHelper = DatabaseHelper();
  }

  Future<Database> get database async {
    return await _databaseHelper.setDatabase();
  }

  Future<int> insertData(
      {required String table, required Map<String, dynamic> data}) async {
    Database _db = await database;
    return await _db.insert(table, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> readData({required String table}) async {
    Database _db = await database;
    return await _db.query(table, orderBy: 'id DESC');
  }

  Future<void> updateData(
      {required String table, required Map<String, dynamic> data}) async {
    Database _db = await database;
    await _db.update(table, data, where: 'id=?', whereArgs: [data['id']]);
  }

  Future<List<Map<String, dynamic>>> search(
      {required String tableName, String? searchQuery, int? taskId}) async {
    Database _db = await database;
    if (taskId != null) {
      return await _db
          .rawQuery('SELECT * FROM $tableName WHERE taskId = $taskId');
    } else {
      if (tableName == 'tasks') {
        return await _db.query(tableName,
            where: 'title LIKE ? OR content LIKE ?',
            whereArgs: ['%$searchQuery%', '%$searchQuery%'], orderBy: 'id DESC');
      } else if (tableName == 'todos') {
        return await _db.query(tableName,
            where: 'title LIKE ?', whereArgs: ['%$searchQuery%'], orderBy: 'id DESC');
      } else {
        return await _db.query(tableName, orderBy: 'id DESC');
      }
    }
  }

  Future<void> deleteData(
      {required String table, id, String? columnName, query}) async {
    Database _db = await database;
    if (id == null) {
      _db.rawDelete('DELETE FROM $table WHERE $columnName = $query');
    } else {
      _db.rawDelete('DELETE FROM $table WHERE id = $id');
    }
  }
}
