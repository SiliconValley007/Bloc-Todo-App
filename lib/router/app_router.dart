import 'package:flutter/material.dart';
import 'package:todo_app/screens/addtask_page.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/screens/settings_page.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/add-task':
        return MaterialPageRoute(
            builder: (_) => AddTaskScreen(
                  task: routeSettings.arguments,
                ));
      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}
