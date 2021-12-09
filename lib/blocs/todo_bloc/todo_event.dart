part of 'todo_bloc.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

class LoadTodos extends TodoEvent {
  final int taskid;
  const LoadTodos({required this.taskid});

  @override
  List<Object> get props => [taskid];
}

class AddTodo extends TodoEvent {
  final Todo todo;
  final bool isNew;
  const AddTodo({required this.todo, required this.isNew});

  @override
  List<Object> get props => [todo, isNew];
}

class UpdateTodo extends TodoEvent {
  final Todo todo;
  final bool isNew;
  const UpdateTodo({required this.todo, required this.isNew});

  @override
  List<Object> get props => [todo, isNew];
}

class DeleteTodo extends TodoEvent {
  final int id;
  final bool isNew;
  final int taskId;
  const DeleteTodo(
      {required this.id, required this.isNew, required this.taskId});

  @override
  List<Object> get props => [id, isNew, taskId];
}
