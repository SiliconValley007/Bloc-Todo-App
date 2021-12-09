import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/blocs/task_bloc/task_bloc.dart';
import 'package:todo_app/blocs/theme_bloc/theme_bloc.dart';
import 'package:todo_app/blocs/todo_bloc/todo_bloc.dart';
import 'package:todo_app/constants/remove_focus.dart';
import 'package:todo_app/router/app_router.dart';
import 'package:todo_app/themes/app_themes.dart';

void main() {
  runApp(MyApp(
    appRouter: AppRouter(),
  ));
}

class MyApp extends StatefulWidget {
  final AppRouter appRouter;
  const MyApp({Key? key, required this.appRouter}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeBloc _themeBloc = ThemeBloc();
  final RemoveFocus _removeFocus = RemoveFocus();

  @override
  void initState() {
    _themeBloc.add(LoadTheme());
    super.initState();
  }

  @override
  void dispose() {
    _themeBloc.close();
    _removeFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TodoBloc>(create: (context) => TodoBloc()),
        BlocProvider<TaskBloc>(
          create: (context) =>
              TaskBloc(todoBloc: BlocProvider.of<TodoBloc>(context)),
        ),
        BlocProvider.value(value: _themeBloc),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          if (state is ThemeLoaded) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              themeMode: state.themeMode,
              theme: MyThemes.lightTheme,
              darkTheme: MyThemes.darkTheme,
              onGenerateRoute: widget.appRouter.onGenerateRoute,
            );
          } else {
            return const Center(child: Text('Error'));
          }
        },
      ),
    );
  }
}
