import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'dashboard_page.dart';
import 'welcome_screen.dart';  // Mengimpor WelcomeScreen
import 'theme_mode_data.dart'; // Pastikan untuk mengimpor ThemeModeData
import 'auth_controller.dart'; // Mengimpor AuthController

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with error handling for duplicate initialization
  await Firebase.initializeApp().catchError((e) {
    if (e.toString().contains('A Firebase App named "[DEFAULT]" already exists')) {
      print('Firebase already initialized.');
    }
  });

  runApp(
    // Wrap the app with ChangeNotifierProvider to manage theme changes
    ChangeNotifierProvider(
      create: (_) => ThemeModeData(), // Initialize ThemeModeData
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthController()), // Menambahkan AuthController ke dalam provider
        ],
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModeData>(
      builder: (context, themeModeData, child) {
        return MaterialApp(
          title: 'Login and Register Switch',
          themeMode: themeModeData.themeMode, // Use the current theme mode
          theme: ThemeData.light(), // Light theme
          darkTheme: ThemeData.dark(), // Dark theme
          initialRoute: '/', // Menetapkan halaman pertama yang ditampilkan
          routes: {
            '/': (context) => WelcomeScreen(),  // Ganti ke WelcomeScreen
            '/login': (context) => LoginPage(),
            '/register': (context) => RegisterPage(),
            '/dashboard': (context) => DashboardPage(),
          },
        );
      },
    );
  }
}
