import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/services/todo_service.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoService _todoService = TodoService();
  int taskId = -1;
  List<Todo> newTodos = [];
  bool isEmpty = true;

  TodoBloc() : super(TodoLoading()) {
    on<TodoEvent>((event, emit) async {
      if (event is LoadTodos) {
        emit(TodoLoading());
        taskId = event.taskid;
        emit(TodoLoaded(todos: await getTodos(taskid: taskId)));
      } else if (event is AddTodo) {
        if (event.isNew) {
          emit(TodoLoaded(todos: await getNewTodos(todo: event.todo)));
        } else {
          await _todoService.saveTodo(todo: event.todo);
          emit(TodoLoaded(todos: await getTodos(taskid: taskId)));
        }
      } else if (event is UpdateTodo) {
        if (event.isNew) {
          emit(TodoLoaded(
              todos: await getNewTodos(
                  todo: event.todo, index: event.todo.taskId)));
        } else {
          await _todoService.updateTodo(todo: event.todo);
          emit(TodoLoaded(todos: await getTodos(taskid: taskId)));
        }
      } else if (event is DeleteTodo) {
        if (event.isNew) {
          emit(TodoLoaded(todos: await getNewTodos(index: event.id)));
        } else {
          if (event.taskId == -1) {
            await _todoService.deleteTodo(id: event.id);
          } else {
            await _todoService.deleteTodo(
              id: event.id,
              query: event.taskId,
            );
          }
          emit(TodoLoaded(todos: await getTodos(taskid: taskId)));
        }
      }
    });
  }

  Future<List<Todo>> getNewTodos({Todo? todo, int? index}) async {
    if (index == null && todo != null) {
      newTodos.add(todo);
    } else if (index != null && todo == null) {
      newTodos.removeAt(index);
    } else if (index != null && todo != null) {
      newTodos[index] = todo;
    }
    List<Todo> _newTodos = [];
    for (Todo todo in newTodos) {
      _newTodos.add(todo);
    }
    return _newTodos;
  }

  Future<List<Todo>> getTodos({required int taskid}) async {
    List<Todo> _todoList = [];
    List<Map<String, dynamic>> _todos = await _todoService.readTodo(id: taskid);
    for (Map<String, dynamic> todo in _todos) {
      _todoList.add(Todo(
          id: todo['id'],
          taskId: todo['taskId'],
          title: todo['title'],
          isComplete: todo['isComplete'] == 'true' ? true : false));
    }
    if (_todoList.isEmpty) {
      isEmpty = true;
    } else {
      isEmpty = false;
    }
    return _todoList;
  }

  void dispose() {
    newTodos.clear();
  }
}
