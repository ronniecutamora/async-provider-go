import 'package:flutter/material.dart';

/// Controls the app-wide [ThemeMode].
///
/// Inject via [ChangeNotifierProvider] in main.dart.
/// Toggle from any screen: `context.read<ThemeProvider>().toggleTheme()`.
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  bool get isDark => _themeMode == ThemeMode.dark;

  /// Switches between light and dark. Call from a settings screen or
  /// a toggle button in the AppBar.
  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}