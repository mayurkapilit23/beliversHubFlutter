import 'package:flutter/material.dart';
import 'package:sam_sir_app/core/constants/navigation_helper_methods.dart';
import 'package:sam_sir_app/core/widgets/auth_button.dart';
import 'package:sam_sir_app/features/home/screens/home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    super.initState();
    _preloadImages();
  }

  Future<void> _preloadImages() async {
    await precacheImage(const AssetImage("assets/png/google.png"), context);
    // ignore: use_build_context_synchronously
    await precacheImage(const AssetImage("assets/png/facebook.png"), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Grid Images
          // Positioned.fill(
          //   child: Opacity(
          //     opacity: 0.4,
          //     child: Image.asset('assets/images/destination.jpg', fit: BoxFit.cover),
          //   ),
          // ),

          // Dark Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.indigoAccent,
                  ],
                ),
              ),
            ),
          ),

          // Bottom Content
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Let's Get Started!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Worship, Sermons, Motivation, Testimonies, Youth, Church Events",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 20),

                  // Reusable Buttons
                  AuthButton(
                    text: "Continue as Guest",
                    icon: null,
                    color: Colors.white10,
                    textColor: Colors.white,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 12),

                  AuthButton(
                    text: "Continue with Email",
                    icon: Icons.email_outlined,
                    color: Colors.white10,
                    textColor: Colors.white,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 12),

                  AuthButton(
                    text: "Continue with Google",
                    customIcon: Image.asset(
                      'assets/png/google.png',
                      height: 20,
                    ),
                    color: Colors.white10,
                    textColor: Colors.white,
                    onPressed: () {
                      navigateTo(context, const HomeScreen());
                    },
                  ),
                  const SizedBox(height: 12),

                  AuthButton(
                    text: "Continue with Facebook",
                    customIcon: Image.asset(
                      'assets/png/facebook.png',
                      height: 24,
                    ),
                    color: Colors.white10,
                    textColor: Colors.white,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 10),

                  const Text('or', style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 10),

                  AuthButton(
                    text: "Continue with Apple",
                    icon: Icons.apple,
                    color: Colors.white,
                    textColor: Colors.black,
                    onPressed: () {},
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
