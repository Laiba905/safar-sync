import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/trip_provider.dart';
import 'providers/network_provider.dart';
import 'package:safar_sync/screens/splash_screen.dart';

// UI State Management (Member 1 ki logic - intact)
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);
final ValueNotifier<String> profileImageNotifier = ValueNotifier('https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200');
final ValueNotifier<String> profileNameNotifier = ValueNotifier('Ayesha Khan');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Firebase Initialize (Member 2 Task)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    // Providers Register (Member 2 Task)
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TripProvider()),
        ChangeNotifierProvider(create: (_) => NetworkProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
