import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String themeKey = 'theme_mode';

  ThemeBloc() : super(const ThemeState(themeMode: ThemeMode.system)) {
    on<LoadTheme>(_onLoadTheme);
    on<ToggleTheme>(_onToggleTheme);
    on<SetTheme>(_onSetTheme);
  }

  Future<void> _onLoadTheme(
      LoadTheme event,
      Emitter<ThemeState> emit,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(themeKey) ?? 2; // Default to system
    emit(ThemeState(themeMode: ThemeMode.values[themeIndex]));
  }

  Future<void> _onToggleTheme(
      ToggleTheme event,
      Emitter<ThemeState> emit,
      ) async {
    final newThemeMode = _getNextThemeMode(state.themeMode);

    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(themeKey, newThemeMode.index);

    emit(ThemeState(themeMode: newThemeMode));
  }

  Future<void> _onSetTheme(
      SetTheme event,
      Emitter<ThemeState> emit,
      ) async {
    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(themeKey, event.themeMode.index);

    emit(ThemeState(themeMode: event.themeMode));
  }

  ThemeMode _getNextThemeMode(ThemeMode current) {
    return current == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
  }

}