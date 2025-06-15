import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(themeMode: ThemeMode.light));

  void toggleTheme() {
    emit(state.themeMode == ThemeMode.light
        ? const ThemeState(themeMode: ThemeMode.dark)
        : const ThemeState(themeMode: ThemeMode.light));
  }
}
