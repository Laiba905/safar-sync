import 'package:flutter/material.dart';
import 'package:safar_sync/screens/splash_screen.dart';
import 'screens/home_screen.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark); // Default Dark set kiya h jaisa screenshots me h
final ValueNotifier<String> profileImageNotifier = ValueNotifier('https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200');
final ValueNotifier<String> profileNameNotifier = ValueNotifier('Ayesha Khan');

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          title: 'SafarSync',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: const Color(0xFFF8FAFC),
            cardColor: Colors.white,
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0D9488),
              onSurface: Colors.black87,
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: const Color(0xFF0F172A),
            cardColor: const Color(0xFF1E293B),
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF0D9488),
              onSurface: Colors.white,
            ),
          ),
          themeMode: currentMode,
          home: const SplashScreen(),
        );
      },
    );
  }
}