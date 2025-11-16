import 'dart:async';
import 'package:believersHub/blocs/auth/auth_bloc.dart';
import 'package:believersHub/blocs/auth/auth_event.dart';
import 'package:believersHub/blocs/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _checkLoginStatus();
  }

  // Splash animation setup
  void _initAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scale = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  // Checking secure storage for refresh token
  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2)); // small splash delay
    String? refreshToken = await storage.read(key: "refreshToken");
    if (!mounted) return;
    if (refreshToken != null) {
      context.read<AuthBloc>().add(AuthLoggedInAutomatically(refreshToken));
    } else {
      context.read<AuthBloc>().add(AuthLoggedOut());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.authenticated) {
          Navigator.pushReplacementNamed(context, "/home");
        } else {
          Navigator.pushReplacementNamed(context, "/login");
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(color: Colors.indigoAccent.shade100),
          child: SafeArea(
            child: Center(
              child: FadeTransition(
                opacity: _fade,
                child: ScaleTransition(
                  scale: _scale,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      FlutterLogo(size: 120),
                      SizedBox(height: 20),
                      Text(
                        'Spread Light Through Every Reel',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
