import 'package:flutter/material.dart';
import 'package:sam_sir_app/core/constants/navigation_helper_methods.dart';
import 'package:sam_sir_app/core/theme/app_colors.dart';
import 'package:sam_sir_app/features/authentication/screens/verify_phone_number_screen.dart';

class InputPhoneNumberScreen extends StatelessWidget {
  const InputPhoneNumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Login Account",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Your will receive a 4 digit code to verify next.",
                style: TextStyle(fontSize: 15, color: Colors.black45),
              ),

              const SizedBox(height: 40),

              TextField(
                autofocus: true,
                keyboardType: TextInputType.phone,
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  hint: Text('Enter Phone Number'),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.indigo, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey, width: 1.5),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // const SizedBox(height: 5),
              // const Text("Get via call", style: TextStyle(color: Colors.blue)),
              const SizedBox(height: 30),
              Spacer(),

              /// Verify Button
              GestureDetector(
                onTap: () => navigateTo(context, VerifyPhoneScreen()),
                child: Container(
                  height: 55,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.indigoAccent,
                    // gradient: const LinearGradient(
                    //   colors: [Color(0xff4F7DF3), Color(0xff335FE2)],
                    // ),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
