import 'package:todo_app/data/repository.dart';
import 'package:todo_app/models/todo.dart';

class TodoService {
  late Repository _repository;

  TodoService() {
    _repository = Repository();
  }

  Future<void> saveTodo({required Todo todo}) async {
    await _repository.insertData(table: 'todos', data: todo.toMap());
  }

  Future<List<Map<String, dynamic>>> readTodo({required int id}) async {
    return await _repository.search(tableName: 'todos', taskId: id);
  }

  Future<void> updateTodo({required Todo todo}) async {
    await _repository.updateData(table: 'todos', data: todo.toMap());
  }

  Future<List<Map<String, dynamic>>> search(
      {required String query}) async {
    return await _repository.search(tableName: 'todos', searchQuery: query);
  }

  Future<void> deleteTodo({required int id, query}) async {
    if(id == -1) {
      await _repository.deleteData(table: 'todos', columnName: 'taskId', query: query);
    } else {
      await _repository.deleteData(table: 'todos', id: id);
    }
  }
}
