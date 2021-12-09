import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_app/blocs/todo_bloc/todo_bloc.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/services/task_service.dart';
import 'package:todo_app/services/todo_service.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TodoBloc todoBloc;
  final TaskService _taskService = TaskService();
  final TodoService _todoService = TodoService();

  TaskBloc({required this.todoBloc}) : super(TaskLoading()) {
    on<TaskEvent>((event, emit) async {
      if (event is LoadTasks) {
        emit(TaskLoading());
        emit(TaskLoaded(tasks: await getAllTasks()));
      } else if (event is AddTask) {
        int taskid = await _taskService.saveTask(task: event.task);
        for (Todo todo in todoBloc.newTodos) {
          todoBloc.add(AddTodo(
              todo: Todo(
                  isComplete: todo.isComplete,
                  taskId: taskid,
                  title: todo.title),
              isNew: false));
        }
        emit(TaskLoaded(tasks: await getAllTasks()));
      } else if (event is UpdateTask) {
        await _taskService.updateTask(task: event.task);
        emit(TaskLoaded(tasks: await getAllTasks()));
      } else if (event is SearchTask) {
        emit(TaskLoading());
        emit(TaskLoaded(tasks: await searchTasks(query: event.query)));
      } else if (event is DeleteTask) {
        await _taskService.deleteTask(id: event.id);
        todoBloc.add(DeleteTodo(id: -1, isNew: false, taskId: event.id));
        emit(TaskLoaded(tasks: await getAllTasks()));
      }
    });
  }

  Future<List<Task>> searchTasks({required String query}) async {
    List<Task> _allTasks = await getAllTasks();
    List<Task> _taskList = [];
    List<Todo> _todosList = [];
    List<Map<String, dynamic>> _tasks = await _taskService.search(query: query);
    List<Map<String, dynamic>> _todos = await _todoService.search(query: query);
    for (Map<String, dynamic> task in _tasks) {
      _taskList.add(
          Task(id: task['id'], title: task['title'], content: task['content']));
    }
    for (Map<String, dynamic> todo in _todos) {
      _todosList.add(Todo(
          id: todo['id'],
          taskId: todo['taskId'],
          title: todo['title'],
          isComplete: todo['isComplete'] == 'true' ? true : false));
    }

    for (int i = 0; i < _todosList.length; i++) {
      for (Task task in _allTasks) {
        if (_todosList[i].taskId == task.id) {
          for (Task filteredtask in _taskList) {
            if (task.id != filteredtask.id) {
              _taskList.add(task);
            }
          }
        }
      }
    }
    return _taskList;
  }

  Future<List<Task>> getAllTasks() async {
    List<Task> _taskList = [];
    List<Map<String, dynamic>> _tasks = await _taskService.readTasks();
    for (Map<String, dynamic> task in _tasks) {
      _taskList.add(
          Task(id: task['id'], title: task['title'], content: task['content']));
    }
    return _taskList;
  }
}
