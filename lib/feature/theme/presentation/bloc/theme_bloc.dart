import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:movie_app/core/services/theme_storage_service.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ThemeStorageService _storageService;

  ThemeBloc(this._storageService)
      : super(ThemeState(isDarkMode: _storageService.getDarkMode())) {
    on<ToggleTheme>(_onToggleTheme);
    on<InitializeTheme>(_onInitializeTheme);
  }

  void _onToggleTheme(ToggleTheme event, Emitter<ThemeState> emit) async {
    final newValue = !state.isDarkMode;
    await _storageService.setDarkMode(newValue);
    emit(ThemeState(isDarkMode: newValue));
  }

  void _onInitializeTheme(InitializeTheme event, Emitter<ThemeState> emit) {
    if (_storageService.isFirstTime()) {
      // Detectar tema del sistema
      final brightness =
          SchedulerBinding.instance.platformDispatcher.platformBrightness;
      final systemIsDark = brightness == Brightness.dark;
      _storageService.setDarkMode(systemIsDark);
      emit(ThemeState(isDarkMode: systemIsDark));
    } else {
      final isDarkMode = _storageService.getDarkMode();
      emit(ThemeState(isDarkMode: isDarkMode));
    }
  }
}
