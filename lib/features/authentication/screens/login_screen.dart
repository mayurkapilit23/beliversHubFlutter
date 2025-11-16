import 'package:flutter/material.dart';
import 'package:believersHub/core/theme/app_colors.dart';
import 'package:believersHub/core/widgets/custom_button.dart';
import 'package:believersHub/core/widgets/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            // Main content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 100),
                    Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Sign in to continue your journey',
                      style: TextStyle(
                        // fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Email field
                    CustomTextField(
                      controller: emailEditingController,
                      hint: 'Email Address',
                    ),
                    const SizedBox(height: 20),

                    // Password field
                    CustomTextField(
                      obscureText: true,
                      controller: passwordEditingController,
                      hint: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.visibility_outlined),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => print("forgot password"),
                        child: Text(
                          'Forgot your password?',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Login Button
                    CustomButton(
                      text: "Sign in",
                      onPressed: () {
                        emailEditingController.clear();
                        passwordEditingController.clear();
                      },
                    ),
                    const SizedBox(height: 20),
                    const Align(alignment: Alignment.center, child: Text('or')),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () {},
                        child: Icon(Icons.face),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Text('Don\'t have an account?'),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Sign Up',

                            style: TextStyle(color: Colors.indigo),
                          ),
                        ),
                      ],
                    ),
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
