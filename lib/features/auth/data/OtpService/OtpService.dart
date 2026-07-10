import 'package:get/get.dart';
import '../../repository/auth_repository.dart';

class OtpService extends GetxService {
  final AuthRepository _authRepository = AuthRepository();

  Future<void> sendOtp(String identifier, String purpose) async {
    await _authRepository.requestOtp(identifier, purpose);
  }

  Future<bool> verifyOtp(String identifier, String code, String purpose) async {
    try {
      final data = {"identifier": identifier, "code": code, "purpose": purpose};
      await _authRepository.verifyOtp(data);
      return true;
    } catch (e) {
      Get.snackbar("خطأ", e.toString());
      return false;
    }
  }
}
