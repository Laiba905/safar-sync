import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    Timer(const Duration(milliseconds: 3500), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Background Design: Blob still positioned to create depth
          Positioned(
            top: -100,
            right: -50,
            child: CircleAvatar(
              radius: 150,
              backgroundColor: const Color(0xFF0D9488).withValues(alpha: 0.05),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0), // Responsiveness
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Spacer above Column to push it slightly up for central balance
                  const Spacer(),

                  // Animated Logo and Tagline grouped together
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            height: 200,
                            width: 200,
                            child: Image.asset(
                              'assets/images/logo1.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Sync Your Trips. Share the Journey.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            letterSpacing: 1.2,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Responsive gap to separate logo/tagline group from the loader
                  // On web/large screens, this will expand slightly; on small screens it shrinks.
                  const Flexible(
                    flex: 1,
                    child: SizedBox(height: 50), // Responsive distance set within Column
                  ),

                  // Animated Loading Indicator (Now aligned relative to tagline)
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: const Center(
                      child: SizedBox(
                        width: 30, // Responsive size slightly smaller
                        height: 30,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0D9488)),
                        ),
                      ),
                    ),
                  ),

                  // Bottom Spacer to balance the layout centrally
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}