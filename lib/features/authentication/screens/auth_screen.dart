import 'package:believersHub/blocs/auth/auth_bloc.dart' show AuthBloc;
import 'package:believersHub/blocs/auth/auth_event.dart';
import 'package:believersHub/blocs/auth/auth_state.dart';
import 'package:believersHub/blocs/global_loading/global_loading_bloc.dart'
    show GlobalLoadingBloc;
import 'package:believersHub/blocs/global_loading/global_loading_event.dart';
import 'package:believersHub/core/constants/navigation_helper_methods.dart';
import 'package:believersHub/core/widgets/auth_button.dart';
import 'package:believersHub/features/authentication/AuthService.dart';
import 'package:believersHub/features/authentication/screens/input_phone_number_screen.dart';
import 'package:believersHub/features/home/screens/home_screen.dart';
import 'package:believersHub/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    super.initState();
    // _preloadImages();
  }

  Future<void> _preloadImages() async {
    await precacheImage(const AssetImage("assets/png/google.png"), context);
    // ignore: use_build_context_synchronously
    await precacheImage(const AssetImage("assets/png/facebook.png"), context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (BuildContext context, state) {
        if (state.authenticated) {
          AppSnackbar.showSuccess(context, "Login successful");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen()),
          );
        } else if (state.message != null) {
          AppSnackbar.showError(context, state.message!);
        }
      },
      child: Scaffold(
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
                    colors: [Colors.transparent, Colors.indigoAccent],
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
                      text: "Continue with Phone Number",
                      icon: Icons.phone_android_outlined,
                      color: Colors.white10,
                      textColor: Colors.white,
                      onPressed: () {
                        navigateTo(context, const InputPhoneNumberScreen());
                      },
                      minWidth: 100, // Minimum width
                      padding: EdgeInsets.symmetric(horizontal: 8),
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
                      onPressed: () async {
                        final user = await AuthService.signInWithGoogle();
                        if (user != null) {
                          final idToken = await user.user!.getIdToken();
                          if (!mounted) return;
                          if (idToken != null) {
                            context.read<GlobalLoadingBloc>().add(ShowLoader());
                            context.read<AuthBloc>().add(
                              AuthLoginRequested(idToken: idToken),
                            );
                          } else {
                            AppSnackbar.showError(
                              context,
                              "Error unable to Sign in",
                            );
                          }
                          context.read<GlobalLoadingBloc>().add(HideLoader());
                        }
                      },
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
