import 'package:believersHub/blocs/auth/auth_bloc.dart';
import 'package:believersHub/blocs/auth/auth_event.dart';
import 'package:believersHub/blocs/auth/auth_state.dart';
import 'package:believersHub/blocs/global_loading/global_loading_bloc.dart';
import 'package:believersHub/blocs/global_loading/global_loading_event.dart';
import 'package:believersHub/core/constants/navigation_helper_methods.dart';
import 'package:believersHub/core/theme/app_colors.dart';
import 'package:believersHub/features/authentication/AuthService.dart';
import 'package:believersHub/features/authentication/screens/verify_phone_number_screen.dart';
import 'package:believersHub/features/home/screens/home_screen.dart';
import 'package:believersHub/utils/app_snackbar.dart' show AppSnackbar;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InputPhoneNumberScreen extends StatefulWidget {
  const InputPhoneNumberScreen({super.key});

  @override
  State<InputPhoneNumberScreen> createState() => _InputPhoneNumberScreenState();
}

class _InputPhoneNumberScreenState extends State<InputPhoneNumberScreen> {
   TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc,AuthState>(
      listener: (BuildContext context, AuthState state) {
        if (state.authenticated) {
          AppSnackbar.showSuccess(context, "Login successful");
          navigateTo(context, HomeScreen());
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
                  "Mobile Number",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Your will receive a 4 digit code to verify next.",
                  style: TextStyle(fontSize: 15, color: Colors.black45),
                ),

                const SizedBox(height: 40),

                TextField(
                  onChanged: (sfs){
                    setState(() {

                    });
                  },
                  controller: controller,
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

                  onTap:controller.text.length==10? () async {
                    context.read<GlobalLoadingBloc>().add(ShowLoader());
                    final user = await AuthService.sendOTP(controller.text);
                    context.read<GlobalLoadingBloc>().add(HideLoader());
                    if (user) {
                      navigateTo(context, VerifyPhoneScreen());
                    }
                  }:null,
                  child: Container(
                    height: 55,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color:controller.text.length==10? Colors.indigoAccent:Colors.grey,
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
      ),
    );
  }
}
