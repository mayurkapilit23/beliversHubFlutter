import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  static String? storedVerificationId;
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      if (kDebugMode) {
        print("Google Login Error: $e");
      }
      return null;
    }
  }

  static Future<UserCredential?> signInWithFacebook() async {
    try {
      final result = await FacebookAuth.instance.login();

      if (result.status != LoginStatus.success) return null;

      final credential = FacebookAuthProvider.credential(
        result.accessToken!.tokenString,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      if (kDebugMode) {
        print("Facebook Login Error: $e");
      }
      return null;
    }
  }

  static Future<UserCredential?> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauth = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      return await FirebaseAuth.instance.signInWithCredential(oauth);
    } catch (e) {
      if (kDebugMode) {
        print("Apple Login Error: $e");
      }
      return null;
    }
  }

  static Future<bool> sendOTP(String phone) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+91$phone",
        timeout: const Duration(seconds: 60),

        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto verification
          await FirebaseAuth.instance.signInWithCredential(credential);
        },

        verificationFailed: (FirebaseAuthException e) {
          print("Phone verification failed: ${e.message}");
        },

        codeSent: (String verificationId, int? resendToken) {
          storedVerificationId = verificationId;
        },

        codeAutoRetrievalTimeout: (String verificationId) {
          storedVerificationId = verificationId;
        },
      );

      return true;
    } catch (e) {
      print("sendOTP Error: $e");
      return false;
    }
  }

  // --------------------------------
  // PHONE LOGIN — VERIFY OTP
  // returns UserCredential? like Google login
  // --------------------------------
  static Future<UserCredential?> verifyOTP(String otp) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: storedVerificationId!,
        smsCode: otp,
      );

      return FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print("verifyOTP Error: $e");
      return null;
    }
  }
}
