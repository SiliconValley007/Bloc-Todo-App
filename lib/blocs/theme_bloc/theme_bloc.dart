import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/data/shared_preference.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SharedPreference _sharedPreference = SharedPreference();

  ThemeBloc() : super(const ThemeLoaded(themeMode: ThemeMode.system)) {
    on<ThemeEvent>((event, emit) async {
      if (event is LoadTheme) {
        emit(ThemeLoaded(themeMode: await getCurrentTheme()));
      } else if (event is ThemeChanged) {
        _sharedPreference.saveTheme(themeMode: event.themeMode);
        emit(ThemeLoaded(themeMode: event.themeMode));
      }
    });
  }

  Future<ThemeMode> getCurrentTheme() async {
    return await _sharedPreference.getTheme();
  }
}
