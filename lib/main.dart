import 'package:believersHub/blocs/global_loading/global_loading_bloc.dart'
    show GlobalLoadingBloc;
import 'package:believersHub/core/theme/app_dark_theme.dart';
import 'package:believersHub/core/theme/app_light_theme.dart';
import 'package:believersHub/features/theme/bloc/theme_bloc.dart';
import 'package:believersHub/features/theme/bloc/theme_state.dart';
import 'package:believersHub/repositories/auth_repository.dart';
import 'package:believersHub/utils/global_loader.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:believersHub/features/authentication/screens/auth_screen.dart';
import 'package:believersHub/features/home/screens/home_screen.dart';
import 'package:believersHub/features/onboarding/screens/onboarding_screen.dart';
import 'package:believersHub/features/onboarding/screens/splash_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/global_loading/global_loading_state.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(authRepository: AuthRepository())),
        BlocProvider(create: (_) => GlobalLoadingBloc()),
        BlocProvider(create: (_) => ThemeBloc()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            routes: {
              '/login': (c) => AuthScreen(),
              '/onboarding': (c) => OnboardingScreen(),
              '/home': (c) => HomeScreen(),
              // '/onboarding': (c) => const OnboardingPage(),
            },
            debugShowCheckedModeBanner: false,
            theme: AppLightTheme.theme,
            darkTheme: AppDarkTheme.theme,
            themeMode: state.themeMode, // controlled by bloc
            home: Stack(
              children: [
                BlocBuilder<GlobalLoadingBloc, GlobalLoadingState>(
                  builder: (context, state) {
                    return GlobalLoader(show: state.isLoading);
                  },
                ),
                const SplashScreen(),
              ],
            ),
          );
        },
      ),
    );
  }
}
