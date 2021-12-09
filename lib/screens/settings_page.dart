import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/blocs/theme_bloc/theme_bloc.dart';
import 'package:todo_app/constants/widgets.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon:
                Icon(Icons.arrow_back, color: Theme.of(context).primaryColor)),
        title: Text(
          'Preferences',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: BlocBuilder<ThemeBloc, ThemeState>(
          bloc: BlocProvider.of<ThemeBloc>(context),
          builder: (context, state) {
            if (state is ThemeLoaded) {
              return Column(
                children: [
                  RadioButton(
                      onTap: () => BlocProvider.of<ThemeBloc>(context)
                          .add(const ThemeChanged(themeMode: ThemeMode.light)),
                      titleText: 'Light Theme',
                      isSelected:
                          state.themeMode == ThemeMode.light ? true : false,
                      textColor: Theme.of(context).primaryColor,
                      selectedColor: Theme.of(context)
                          .floatingActionButtonTheme
                          .backgroundColor!),
                  RadioButton(
                      onTap: () => BlocProvider.of<ThemeBloc>(context)
                          .add(const ThemeChanged(themeMode: ThemeMode.dark)),
                      titleText: 'Dark Theme',
                      isSelected:
                          state.themeMode == ThemeMode.dark ? true : false,
                      textColor: Theme.of(context).primaryColor,
                      selectedColor: Theme.of(context)
                          .floatingActionButtonTheme
                          .backgroundColor!),
                  RadioButton(
                      onTap: () => BlocProvider.of<ThemeBloc>(context)
                          .add(const ThemeChanged(themeMode: ThemeMode.system)),
                      titleText: 'System Theme',
                      textColor: Theme.of(context).primaryColor,
                      isSelected:
                          state.themeMode == ThemeMode.system ? true : false,
                      selectedColor: Theme.of(context)
                          .floatingActionButtonTheme
                          .backgroundColor!),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
