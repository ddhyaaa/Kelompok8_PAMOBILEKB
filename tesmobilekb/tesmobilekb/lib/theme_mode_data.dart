import 'package:flutter/material.dart';

// Kelas ThemeModeData untuk mengelola perubahan mode tema
class ThemeModeData extends ChangeNotifier {
  // Tema default adalah terang (light)
  ThemeMode _themeMode = ThemeMode.light;

  // Getter untuk memeriksa apakah mode gelap sedang aktif
  bool get isDarkModeActive => _themeMode == ThemeMode.dark;

  // Getter untuk mengambil mode tema saat ini
  ThemeMode get themeMode => _themeMode;

  // Metode untuk mengubah mode tema
  void changeTheme(ThemeMode themeMode) {
    _themeMode = themeMode;  // Mengubah mode tema
    notifyListeners(); // Memberitahu widget bahwa tema telah berubah
  }
}
