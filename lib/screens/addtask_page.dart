import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/blocs/task_bloc/task_bloc.dart';
import 'package:todo_app/blocs/todo_bloc/todo_bloc.dart';
import 'package:todo_app/constants/remove_focus.dart';
import 'package:todo_app/constants/widgets.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/models/todo.dart';

class AddTaskScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final task;
  const AddTaskScreen({Key? key, this.task}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late TaskBloc _taskBloc;
  late TodoBloc _todoBloc;

  final RemoveFocus _removeFocus = RemoveFocus();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _newTodoController = TextEditingController();

  @override
  void initState() {
    _taskBloc = BlocProvider.of<TaskBloc>(context);
    _todoBloc = BlocProvider.of<TodoBloc>(context);
    if (widget.task != null) {
      _titleController.text = widget.task.title;
      _contentController.text = widget.task.content;
      _todoBloc.add(LoadTodos(taskid: widget.task.id));
    } else {
      _todoBloc.add(const LoadTodos(taskid: -1));
    }
    super.initState();
  }

  @override
  void dispose() {
    _todoBloc.dispose();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => _removeFocus.removeFocus(context),
        child: Scaffold(
          body: Body(
            passedTask: widget.task,
            titleController: _titleController,
            contentController: _contentController,
            newTodoController: _newTodoController,
            todoBloc: _todoBloc,
            taskBloc: _taskBloc,
            removeFocus: _removeFocus,
          ),
        ),
      );
}

class Body extends StatelessWidget {
  final Task? passedTask;
  final TextEditingController titleController;
  final TextEditingController contentController;
  final TextEditingController newTodoController;
  final TodoBloc todoBloc;
  final TaskBloc taskBloc;
  final RemoveFocus removeFocus;
  const Body({
    Key? key,
    this.passedTask,
    required this.titleController,
    required this.contentController,
    required this.newTodoController,
    required this.todoBloc,
    required this.taskBloc,
    required this.removeFocus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (passedTask != null) {
          if (contentController.text.isEmpty &&
              titleController.text.isEmpty &&
              todoBloc.isEmpty) {
            taskBloc.add(DeleteTask(id: passedTask!.id!));
          } else {
            taskBloc.add(UpdateTask(
                task: Task(
                    id: passedTask!.id,
                    title: titleController.text,
                    content: contentController.text)));
          }
        } else {
          if (contentController.text.isNotEmpty ||
              titleController.text.isNotEmpty ||
              todoBloc.newTodos.isNotEmpty) {
            taskBloc.add(AddTask(
                task: Task(
                    title: titleController.text,
                    content: contentController.text)));
          }
        }
        Navigator.pop(context);
        return true;
      },
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Icon(Icons.arrow_back_ios),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      cursorColor: Theme.of(context)
                          .floatingActionButtonTheme
                          .backgroundColor,
                      controller: titleController,
                      decoration: const InputDecoration(
                        hintText: 'Enter Task Title',
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                          fontSize: 26.0,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      if (passedTask != null) {
                        taskBloc.add(DeleteTask(id: passedTask!.id!));
                      }
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Icon(Icons.delete,
                          color: Theme.of(context).iconTheme.color),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextField(
                keyboardType: TextInputType.multiline,
                cursorColor:
                    Theme.of(context).floatingActionButtonTheme.backgroundColor,
                maxLines: null,
                controller: contentController,
                decoration: const InputDecoration(
                    hintText: 'Enter Content...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 24.0)),
                style: TextStyle(
                    fontSize: 16.0, color: Theme.of(context).bottomAppBarColor),
              ),
              const SizedBox(
                height: 26.0,
              ),
              BlocBuilder(
                bloc: todoBloc,
                builder: (BuildContext context, TodoState state) {
                  if (state is TodoLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is TodoLoaded) {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return TodoWidget(
                            onSave: (value) {
                              if (passedTask == null) {
                                todoBloc.add(
                                  UpdateTodo(
                                      todo: Todo(
                                          id: state.todos[index].id,
                                          taskId: index,
                                          title: value,
                                          isComplete:
                                              state.todos[index].isComplete),
                                      isNew: true),
                                );
                              } else {
                                todoBloc.add(
                                  UpdateTodo(
                                      todo: Todo(
                                          id: state.todos[index].id,
                                          taskId: passedTask!.id!,
                                          title: value,
                                          isComplete:
                                              state.todos[index].isComplete),
                                      isNew: false),
                                );
                              }
                            },
                            onTap: () {
                              if (passedTask == null) {
                                todoBloc.add(
                                  UpdateTodo(
                                      todo: Todo(
                                          id: state.todos[index].id,
                                          taskId: index,
                                          title: state.todos[index].title,
                                          isComplete:
                                              !state.todos[index].isComplete),
                                      isNew: true),
                                );
                              } else {
                                todoBloc.add(
                                  UpdateTodo(
                                      todo: Todo(
                                          id: state.todos[index].id,
                                          taskId: passedTask!.id!,
                                          title: state.todos[index].title,
                                          isComplete:
                                              !state.todos[index].isComplete),
                                      isNew: false),
                                );
                              }
                            },
                            todotitle: state.todos[index].title,
                            isComplete: state.todos[index].isComplete,
                            onTapDelete: () {
                              if (passedTask == null) {
                                todoBloc.add(
                                  DeleteTodo(
                                      id: index, isNew: true, taskId: index),
                                );
                              } else {
                                todoBloc.add(
                                  DeleteTodo(
                                      id: state.todos[index].id!,
                                      isNew: false,
                                      taskId: -1),
                                );
                              }
                              removeFocus.removeFocus(context);
                            },
                          );
                        },
                        itemCount: state.todos.length);
                  } else {
                    return const Center(child: Text('Error'));
                  }
                },
              ),
              const SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        if (newTodoController.text.isNotEmpty) {
                          if (passedTask == null) {
                            todoBloc.add(AddTodo(
                                todo: Todo(
                                    taskId: 0,
                                    title: newTodoController.text,
                                    isComplete: false),
                                isNew: true));
                          } else {
                            todoBloc.add(AddTodo(
                                todo: Todo(
                                    taskId: passedTask!.id!,
                                    title: newTodoController.text,
                                    isComplete: false),
                                isNew: false));
                          }
                          newTodoController.clear();
                        }
                      },
                      child: Icon(Icons.add,
                          color: Theme.of(context).bottomAppBarColor),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        cursorColor: Theme.of(context)
                            .floatingActionButtonTheme
                            .backgroundColor,
                        onSubmitted: (value) {
                          if (newTodoController.text.isNotEmpty) {
                            if (passedTask == null) {
                              todoBloc.add(
                                AddTodo(
                                    todo: Todo(
                                        taskId: 0,
                                        title: value,
                                        isComplete: false),
                                    isNew: true),
                              );
                            } else {
                              todoBloc.add(
                                AddTodo(
                                    todo: Todo(
                                        taskId: passedTask!.id!,
                                        title: value,
                                        isComplete: false),
                                    isNew: false),
                              );
                            }
                            newTodoController.clear();
                          }
                        },
                        controller: newTodoController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: 'Add Todo...',
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Theme.of(context).bottomAppBarColor),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
