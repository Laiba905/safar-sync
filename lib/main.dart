import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  // Ensure Flutter bindings are initialized before app launch
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafarSync',
      debugShowCheckedModeBanner: false,

      // ☀️ Light Mode Theme Configuration
      theme: AppTheme.lightTheme,

      // 🌙 Dark Mode Theme Configuration
      darkTheme: AppTheme.darkTheme,

      // 🔄 System settings ke mutabik automatic light/dark switch hoga
      themeMode: ThemeMode.system,

      // 🚀 App starting point set to Animated Splash Screen
      home: const SplashScreen(),
    );
  }
}