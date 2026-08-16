// import 'package:get/get.dart';
// import '../../auth/repository/auth_repository.dart';
// import '../../../features/NewPassword/view/new_password_screen.dart';
import 'package:tabibi/features/NewPassword/binding/new_password_binding.dart';
//
// class OtpController extends GetxController {
//   final AuthRepository _authRepository = AuthRepository();
//
//   var isLoading = false.obs;
//   var otp = ''.obs;
//
//   late String identifier;
//   late String purpose;
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     if (Get.arguments is Map<String, dynamic>) {
//       final arguments = Get.arguments as Map<String, dynamic>;
//       identifier = arguments['identifier'] ?? '';
//       purpose = arguments['purpose'] ?? 'register';
//     } else {
//       identifier = '';
//       purpose = 'register';
//     }
//   }
//
//   void setOtp(String value) => otp.value = value.trim();
//
//   Future<void> verifyOtp() async {
//     if (otp.value.length < 6) {
//       Get.snackbar("ØªÙ†Ø¨ÙŠÙ‡", "ÙŠØ±Ø¬Ù‰ Ø¥Ø¯Ø®Ø§Ù„ Ø±Ù…Ø² Ø§Ù„ØªØ­Ù‚Ù‚");
//       return;
//     }
//
//     try {
//       isLoading.value = true;
//
//       final Map<String, dynamic> data = {"code": otp.value.trim()};
//
//       if (identifier.contains("@")) {
//         data["email"] = identifier.trim();
//       } else {
//         data["phone"] = identifier.trim();
//       }
//
//       await _authRepository.verifyOtp(data);
//
//       Get.snackbar("Ù†Ø¬Ø§Ø­", "ØªÙ… Ø§Ù„ØªØ­Ù‚Ù‚ Ø¨Ù†Ø¬Ø§Ø­");
//
//       if (purpose == 'reset-password') {
//         Get.to(
//           () => NewPasswordScreen(),
//           arguments: {'identifier': identifier, 'otp': otp.value.trim()},
//         );
//       } else {
//         Get.offAllNamed('/home');
//       }
//     } catch (e) {
//       Get.snackbar("Ø®Ø·Ø£", e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }


import 'package:get/get.dart';
import '../../auth/repository/auth_repository.dart';
import '../../../features/NewPassword/view/new_password_screen.dart';

class OtpController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  var isLoading = false.obs;
  var otp = ''.obs;

  late String identifier;
  late String purpose;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments is Map<String, dynamic>) {
      final arguments = Get.arguments as Map<String, dynamic>;
      identifier = arguments['identifier'] ?? '';
      purpose = arguments['purpose'] ?? 'register';
    } else {
      identifier = '';
      purpose = 'register';
    }
  }

  void setOtp(String value) => otp.value = value.trim();

  Future<void> verifyOtp() async {
    if (otp.value.length < 6) {
      Get.snackbar('Notice', 'Enter the verification code.');
      return;
    }

    if (purpose == 'reset-password') {
      // The reset endpoint validates this code and changes the password.
      // Account verification would clear the code before the reset request.
      Get.to(
        () => NewPasswordScreen(),
        binding: NewPasswordBinding(),
        arguments: {'identifier': identifier, 'otp': otp.value.trim()},
      );
      return;
    }

    try {
      isLoading.value = true;
      final Map<String, dynamic> data = {'code': otp.value.trim()};
      if (identifier.contains('@')) {
        data['email'] = identifier.trim();
      } else {
        data['phone'] = identifier.trim();
      }
      await _authRepository.verifyOtp(data);
      Get.snackbar('Success', 'Account verified successfully.');
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> resendOtp() async {
    if (identifier.isEmpty) {
      Get.snackbar("Ø®Ø·Ø£", "Ø§Ù„Ù…Ø¹Ø±Ù ØºÙŠØ± Ù…ØªÙˆÙØ±ØŒ ÙŠØ±Ø¬Ù‰ Ø§Ù„Ù…Ø­Ø§ÙˆÙ„Ø© Ù„Ø§Ø­Ù‚Ø§Ù‹");
      return;
    }

    try {
      isLoading.value = true;

      await _authRepository.resendVerification(identifier);

      Get.snackbar("Ù†Ø¬Ø§Ø­", "ØªÙ… Ø¥Ø±Ø³Ø§Ù„ Ø±Ù…Ø² ØªØ­Ù‚Ù‚ Ø¬Ø¯ÙŠØ¯ Ø¨Ù†Ø¬Ø§Ø­");
    } catch (e) {
      Get.snackbar("Ø®Ø·Ø£", e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }
}
