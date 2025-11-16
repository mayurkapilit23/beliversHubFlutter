import 'package:flutter/material.dart';
import 'package:believersHub/core/constants/navigation_helper_methods.dart';
import 'package:believersHub/features/authentication/screens/auth_screen.dart';
import 'package:believersHub/features/onboarding/models/onboarding_model.dart';

import 'onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    super.initState();
    _preloadImages();
  }

  Future<void> _preloadImages() async {
    await precacheImage(const AssetImage("assets/png/blueberry.png"), context);
    // ignore: use_build_context_synchronously
    // await precacheImage(
    //   const AssetImage("assets/images/destination.jpg"),
    //   context,
    // );
  }

  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<OnboardingModel> screens = [
    OnboardingModel(
      image: 'assets/png/blueberry.png',
      title: 'Welcome to ReelUp',
      subtitle: 'Watch, upload and explore amazing reels easily.',
    ),
    OnboardingModel(
      image: 'assets/png/blueberry.png',
      title: 'Create Stunning Reels',
      subtitle: 'Add effects, music, filters and share your creativity.',
    ),
    OnboardingModel(
      image: 'assets/png/blueberry.png',
      title: 'Connect & Grow',
      subtitle: 'Follow creators, like, comment and grow your audience.',
    ),
  ];

  void nextPage() {
    if (currentIndex == screens.length - 1) {
      // Navigate to your home screen or auth screen
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigoAccent.shade100,
      // backgroundColor: Colors.pinkAccent.withOpacity(0.2),
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => navigateTo(context, AuthScreen()),

                child: Text(
                  "Skip",
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
              ),
            ),

            // Pages
            Expanded(
              flex: 8,
              child: PageView.builder(
                controller: _controller,
                itemCount: screens.length,
                onPageChanged: (index) {
                  setState(() => currentIndex = index);
                },
                itemBuilder: (_, i) {
                  return OnboardingPage(
                    image: screens[i].image,
                    title: screens[i].title,
                    subtitle: screens[i].subtitle,
                  );
                },
              ),
            ),

            // Dots Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                screens.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: currentIndex == index ? 22 : 8,
                  decoration: BoxDecoration(
                    color: currentIndex == index
                        ? Colors.indigoAccent
                        : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Next / Get Started button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton(
                onPressed: () => navigateTo(context, AuthScreen()),
                // onPressed: nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigoAccent,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  currentIndex == screens.length - 1 ? "Get Started" : "Next",
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
