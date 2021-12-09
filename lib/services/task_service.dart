import 'package:todo_app/data/repository.dart';
import 'package:todo_app/models/task.dart';

class TaskService {
  late Repository _repository;

  TaskService() {
    _repository = Repository();
  }

  Future<int> saveTask({required Task task}) async {
    return await _repository.insertData(table: 'tasks', data: task.toMap());
  }

  Future<List<Map<String, dynamic>>> readTasks() async {
    return await _repository.readData(table: 'tasks');
  }

  Future<List<Map<String, dynamic>>> search(
      {required String query}) async {
    return await _repository.search(tableName: 'tasks', searchQuery: query);
  }

  Future<void> updateTask({required Task task}) async {
    await _repository.updateData(table: 'tasks', data: task.toMap());
  }

  Future<void> deleteTask({required id}) async {
    await _repository.deleteData(table: 'tasks', id: id);
  }
}
