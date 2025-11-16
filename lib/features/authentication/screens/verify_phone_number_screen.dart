import 'package:believersHub/blocs/auth/auth_bloc.dart';
import 'package:believersHub/blocs/auth/auth_event.dart';
import 'package:believersHub/blocs/auth/auth_state.dart';
import 'package:believersHub/blocs/global_loading/global_loading_bloc.dart';
import 'package:believersHub/blocs/global_loading/global_loading_event.dart';
import 'package:believersHub/core/constants/navigation_helper_methods.dart';
import 'package:believersHub/core/theme/app_colors.dart';
import 'package:believersHub/features/authentication/AuthService.dart';
import 'package:believersHub/features/authentication/widgets/otp_input_field.dart';
import 'package:believersHub/features/home/screens/home_screen.dart';
import 'package:believersHub/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyPhoneScreen extends StatefulWidget {
  const VerifyPhoneScreen({super.key});

  @override
  State<VerifyPhoneScreen> createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  final List<TextEditingController> controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  void handleOtpChange(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      FocusScope.of(context).nextFocus(); // Move to next box
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).previousFocus(); // Backspace → move back
    }
  }

  String getOtp() {
    return controllers.map((c) => c.text).join();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc,AuthState>(
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
                  "Verify Phone",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Code is sent to 9944552288",
                  style: TextStyle(fontSize: 15, color: Colors.black45),
                ),

                const SizedBox(height: 40),

                /// OTP Fields
                OtpInputField(
                  controllers: controllers,
                  onChanged: handleOtpChange,
                ),

                const SizedBox(height: 16),
                const Text(
                  "Resend code in 00:17",
                  style: TextStyle(color: Colors.grey),
                ),

                // const SizedBox(height: 5),
                // const Text("Get via call", style: TextStyle(color: Colors.blue)),
                const SizedBox(height: 30),
                Spacer(),

                /// Verify Button
                GestureDetector(
                  onTap: () async{
                    context.read<GlobalLoadingBloc>().add(ShowLoader());
                    final userCred = await AuthService.verifyOTP(getOtp());
                    if (userCred != null) {
                      final idToken = await userCred.user?.getIdToken();
                      context.read<AuthBloc>().add(
                        AuthLoginRequested(idToken: idToken.toString()),
                      );
                      context.read<GlobalLoadingBloc>().add(HideLoader());
                    }

                  },
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
                      "Verify",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
