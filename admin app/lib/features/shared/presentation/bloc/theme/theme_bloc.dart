import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SharedPreferences sharedPreferences;
  final String key = 'theme';
  ThemeBloc({
    required this.sharedPreferences,
  }) : super(const ThemeState()) {
    on<ChangeThemeEvent>((event, emit) {
      setTheme(event.themeMode);
      emit(state.copyWith(themeMode: event.themeMode));
    });

    final themeMode = getTheme();
    add(ChangeThemeEvent(themeMode: themeMode));
  }

  void setTheme(ThemeMode themeMode) {
    if (themeMode == ThemeMode.system) {
      sharedPreferences.setString(key, "System");
    } else if (themeMode == ThemeMode.light) {
      sharedPreferences.setString(key, "light");
    } else {
      sharedPreferences.setString(key, "dark");
    }
  }

  ThemeMode getTheme() {
    final theme = sharedPreferences.getString(key);
    if (theme == "System") {
      return ThemeMode.system;
    } else if (theme == "light") {
      return ThemeMode.light;
    } else {
      return ThemeMode.dark;
    }
  }
}
