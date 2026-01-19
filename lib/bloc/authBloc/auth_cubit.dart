import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_mobile/progress_loader_screen.dart';
import 'package:paw_pal_mobile/services/firebase_auth_service.dart';

import '../../core/AppStrings.dart';
import '../../core/CommonMethods.dart';
import '../../routes/routes.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  ValueNotifier<bool> isLoading = ValueNotifier(false);

  String? _verificationId;
  int? _resendToken;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> sendFirebaseOTP(BuildContext context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: "+1$phoneNumber",
        timeout: const Duration(seconds: 60),
        forceResendingToken: _resendToken,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          debugPrint("Verification failed: ${e.code} - ${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          _resendToken = resendToken;
          CommonMethods().showSuccessToast(AppStrings.otpSent);
          context.pushNamed(Routes.otpScreen);
          debugPrint("Verification ID: $verificationId");
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> onVerifyOtp({
    required String smsCode,
    required BuildContext context,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId ?? "",
        smsCode: smsCode,
      );

      final userCredential = await auth.signInWithCredential(credential);
      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        return;
      }
      final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
      final bool isProfileComplete = await FirebaseAuthService().isProfileCompleted(firebaseUser.uid);
      if (!context.mounted) return;
      if (isNewUser || !isProfileComplete) {
        context.goNamed(Routes.setupProfileScreen);
      } else {
        context.goNamed(Routes.dashBoardScreen);
      }
    } on FirebaseAuthException catch (e) {
      final errorMessage = CommonMethods.getFirebaseAuthErrorMessage(e);
      CommonMethods().showErrorToast(errorMessage);
      debugPrint("Errror${e.toString()}");
    } catch (e) {
      debugPrint("Errror${e.toString()}");
      CommonMethods().showErrorToast(AppStrings.otpVerificationFailed);
    }
  }
}
