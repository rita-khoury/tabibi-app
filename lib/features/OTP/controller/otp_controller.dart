import 'dart:async';

import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../NewPassword/binding/new_password_binding.dart';
import '../../NewPassword/view/new_password_screen.dart';
import '../../auth/data/models/auth_response_model.dart';
import '../../auth/repository/AuthController.dart';
import '../../auth/repository/auth_repository.dart';

enum OtpFlowType { registration, forgotPassword }

class OtpController extends GetxController {
  static const List<int> _resendCooldowns = <int>[30, 60, 120, 240, 1800, 7200];

  final AuthRepository _authRepository = AuthRepository();
  final AuthController _authController = Get.find<AuthController>();

  final isLoading = false.obs;
  final otp = ''.obs;
  final resendCountdownSeconds = 0.obs;
  late String identifier;
  late String purpose;
  late String password;
  late OtpFlowType flowType;
  Timer? _resendTimer;
  int _resendAttempt = 0;

  bool get canResend =>
      !isLoading.value && resendCountdownSeconds.value == 0;

  String get resendCountdownLabel {
    final seconds = resendCountdownSeconds.value;
    if (seconds >= 3600) {
      return '${seconds ~/ 3600}h ${(seconds % 3600) ~/ 60}m';
    }
    if (seconds >= 60) {
      return '${seconds ~/ 60}m ${seconds % 60}s';
    }
    return '00:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments is Map) {
      identifier = arguments['identifier']?.toString().trim() ?? '';
      purpose = arguments['purpose']?.toString() ?? 'register';
      password = arguments['password']?.toString() ?? '';
    } else {
      identifier = '';
      purpose = 'register';
      password = '';
    }
    flowType = purpose == 'reset-password'
        ? OtpFlowType.forgotPassword
        : OtpFlowType.registration;
    _startResendCooldown(30);
  }

  @override
  void onClose() {
    _resendTimer?.cancel();
    super.onClose();
  }

  void setOtp(String value) => otp.value = value.trim();

  Future<void> verifyOtp() async {
    if (otp.value.length < 6) {
      Get.snackbar('Notice', 'Enter the verification code.');
      return;
    }

    if (flowType == OtpFlowType.forgotPassword) {
      Get.to(
        () => NewPasswordScreen(),
        binding: NewPasswordBinding(),
        arguments: {'identifier': identifier, 'otp': otp.value},
      );
      return;
    }

    try {
      isLoading.value = true;
      final verification = await _authRepository.verifyOtp(_verificationPayload());
      final auth = _authFromVerification(verification) ??
          await _loginAfterVerification();

      if (auth == null) {
        throw Exception('Account verified, but automatic sign-in could not be completed.');
      }
      if (auth.role?.trim().toUpperCase() != 'PATIENT') {
        throw Exception('Access denied. Only patient accounts are allowed to log in to this app.');
      }

      await _authController.loginSuccess(
        auth.user,
        auth.accessToken,
        auth.refreshToken,
      );
      await _authController.updateProfileCompletionStatus(auth.profileCompleted);
      Get.offAllNamed(AppRoutes.home);
    } catch (error) {
      Get.snackbar(
        'Error',
        error.toString().replaceFirst(RegExp(r'^Exception:\s*'), ''),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic> _verificationPayload() {
    final data = <String, dynamic>{'code': otp.value};
    if (identifier.contains('@')) {
      data['email'] = identifier;
    } else {
      data['phone'] = identifier;
    }
    return data;
  }

  AuthResponseModel? _authFromVerification(Map<String, dynamic> response) {
    final rawPayload = response['data'];
    final payload = rawPayload is Map
        ? Map<String, dynamic>.from(rawPayload)
        : Map<String, dynamic>.from(response);
    final accessToken = payload['accessToken'] ?? payload['token'];
    final user = payload['user'];
    if (accessToken == null || accessToken.toString().trim().isEmpty || user is! Map) {
      return null;
    }
    return AuthResponseModel.fromJson({
      ...payload,
      'accessToken': accessToken,
      'refreshToken': payload['refreshToken'] ?? '',
      'user': Map<String, dynamic>.from(user),
    });
  }

  Future<AuthResponseModel?> _loginAfterVerification() async {
    if (identifier.isEmpty || password.isEmpty) return null;
    return _authRepository.login(identifier, password);
  }

  Future<void> resendOtp() async {
    if (!canResend) return;
    if (identifier.isEmpty) {
      Get.snackbar('Error', 'Verification identifier is unavailable. Please register again.');
      return;
    }

    try {
      isLoading.value = true;
      if (flowType == OtpFlowType.forgotPassword) {
        await _authRepository.requestOtp(identifier, 'reset-password');
      } else {
        await _authRepository.resendVerification(identifier);
      }

      _startResendCooldown(_cooldownForAttempt(_resendAttempt));
      _resendAttempt += 1;
      Get.snackbar(
        'Success',
        flowType == OtpFlowType.forgotPassword
            ? 'Password reset code resent successfully.'
            : 'Verification code resent successfully.',
      );
    } catch (error) {
      Get.snackbar(
        'Error',
        error.toString().replaceFirst(RegExp(r'^Exception:\s*'), ''),
      );
    } finally {
      isLoading.value = false;
    }
  }

  int _cooldownForAttempt(int attempt) {
    final index = attempt.clamp(0, _resendCooldowns.length - 1);
    return _resendCooldowns[index];
  }

  void _startResendCooldown(int seconds) {
    _resendTimer?.cancel();
    resendCountdownSeconds.value = seconds;
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCountdownSeconds.value <= 1) {
        resendCountdownSeconds.value = 0;
        timer.cancel();
      } else {
        resendCountdownSeconds.value -= 1;
      }
    });
  }
}