part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class LoadTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  final Task task;
  const AddTask({required this.task});

  @override
  List<Object> get props => [task];
}

class UpdateTask extends TaskEvent {
  final Task task;
  const UpdateTask({required this.task});

  @override
  List<Object> get props => [task];
}

class SearchTask extends TaskEvent {
  final String query;
  const SearchTask({required this.query});

  @override
  List<Object> get props => [query];
}

class DeleteTask extends TaskEvent {
  final int id;
  const DeleteTask({required this.id});

  @override
  List<Object> get props => [id];
}
