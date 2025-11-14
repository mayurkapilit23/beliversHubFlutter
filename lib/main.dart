import 'package:flutter/material.dart';
import 'package:sam_sir_app/features/authentication/screens/auth_screen.dart';
import 'package:sam_sir_app/features/home/screens/home_screen.dart';
import 'package:sam_sir_app/features/onboarding/screens/onboarding_screen.dart';
import 'package:sam_sir_app/features/onboarding/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/login': (c) => AuthScreen(),
        '/onboarding': (c) => OnboardingScreen(),
        '/home': (c) => HomeScreen(),
        // '/onboarding': (c) => const OnboardingPage(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'poppins'),
      home: const SplashScreen(
        assetName: 'assets/png/blueberry.png',
        nextRouteName: '/onboarding',
        duration: Duration(seconds: 1),
      ),
    );
  }
}
