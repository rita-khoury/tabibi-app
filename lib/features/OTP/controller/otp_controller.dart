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
      Get.snackbar("تنبيه", "يرجى إدخال رمز التحقق");
      return;
    }

    try {
      isLoading.value = true;

      final Map<String, dynamic> data = {"code": otp.value.trim()};

      if (identifier.contains("@")) {
        data["email"] = identifier.trim();
      } else {
        data["phone"] = identifier.trim();
      }

      await _authRepository.verifyOtp(data);

      Get.snackbar("نجاح", "تم التحقق بنجاح");

      if (purpose == 'reset-password') {
        Get.to(
          () => NewPasswordScreen(),
          arguments: {'identifier': identifier, 'otp': otp.value.trim()},
        );
      } else {
        Get.offAllNamed('/home');
      }
    } catch (e) {
      Get.snackbar("خطأ", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
