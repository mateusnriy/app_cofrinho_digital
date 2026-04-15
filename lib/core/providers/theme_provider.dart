import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  static const _boxName = 'settings';
  static const _themeKey = 'theme_mode';

  ThemeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  void _loadTheme() {
    final box = Hive.box(_boxName);
    final savedTheme = box.get(_themeKey) as String?;

    if (savedTheme == 'light') {
      state = ThemeMode.light;
    } else if (savedTheme == 'dark') {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.system;
    }
  }

  void toggleTheme() {
    final box = Hive.box(_boxName);

    if (state == ThemeMode.dark) {
      state = ThemeMode.light;
      box.put(_themeKey, 'light');
    } else if (state == ThemeMode.light) {
      state = ThemeMode.dark;
      box.put(_themeKey, 'dark');
    } else {
      // Se estiver no automático (system), força o escuro ou claro baseando-se no atual
      final isPlatformDark =
          WidgetsBinding.instance.platformDispatcher.platformBrightness ==
              Brightness.dark;
      if (isPlatformDark) {
        state = ThemeMode.light;
        box.put(_themeKey, 'light');
      } else {
        state = ThemeMode.dark;
        box.put(_themeKey, 'dark');
      }
    }
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});
