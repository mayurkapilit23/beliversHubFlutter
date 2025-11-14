import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final String? nextRouteName;
  final Duration duration;
  final String? assetName;

  const SplashScreen({
    super.key,
    this.nextRouteName,
    this.duration = const Duration(seconds: 3),
    this.assetName,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scale = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    Timer(widget.duration, _goNext);
  }

  void _goNext() {
    if (!mounted) return;

    if (widget.nextRouteName != null) {
      try {
        Navigator.of(context).pushReplacementNamed(widget.nextRouteName!);
      } catch (_) {
        // If named route doesn't exist, silently ignore. Caller should
        // provide a valid route name. Avoid crashing the splash.
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Colors.indigoAccent.shade100),
        // decoration: BoxDecoration(color: AppColors.primaryColor),
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fade,
              child: ScaleTransition(
                scale: _scale,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.assetName != null)
                      Image.asset(
                        widget.assetName!,
                        width: 120,
                        height: 120,
                        fit: BoxFit.contain,
                      )
                    else
                      const FlutterLogo(size: 120),
                    const SizedBox(height: 20),
                    const Text(
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
    );
  }
}
