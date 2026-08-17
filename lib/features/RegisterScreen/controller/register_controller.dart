import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constance/api_constants.dart';
import '../../OTP/binding/otp_binding.dart';
import '../../OTP/view/otp_screen.dart';
import '../../auth/repository/auth_repository.dart';

class RegisterController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final isLoading = false.obs;
  final emailOrPhone = ''.obs;
  final password = ''.obs;
  final firstName = ''.obs;
  final fatherName = ''.obs;
  final lastName = ''.obs;
  final address = ''.obs;
  final birthDate = ''.obs;
  final gender = 'male'.obs;
  final selectedCountry = Rx<dynamic>(null);
  final Rx<File?> selectedAvatarFile = Rx<File?>(null);

  void setGender(String value) => gender.value = value.toLowerCase().trim();

  void setBirthDate(String value) => birthDate.value = value;

  void setPassword(String value) => password.value = value;

  void setCountry(dynamic country) => selectedCountry.value = country;

  Future<void> pickAvatar(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source, imageQuality: 70);
    if (image != null) {
      selectedAvatarFile.value = File(image.path);
    }
  }

  Future<void> register() async {
    if (firstName.value.isEmpty ||
        fatherName.value.isEmpty ||
        lastName.value.isEmpty ||
        address.value.isEmpty ||
        password.value.isEmpty ||
        emailOrPhone.value.isEmpty) {
      Get.snackbar('Notice', 'Please fill in all required fields.');
      return;
    }

    if (password.value.length < 8) {
      Get.snackbar('Notice', 'Password must be at least 8 characters.');
      return;
    }

    try {
      isLoading.value = true;
      final input = emailOrPhone.value.trim();
      final parsedDate = DateTime.parse(birthDate.value);
      final normalizedIdentifier =
      input.contains('@') ? input : _formatPhone(input);
      final mapData = <String, dynamic>{
        'password': password.value.trim(),
        'firstName': firstName.value.trim(),
        'fatherName': fatherName.value.trim(),
        'lastName': lastName.value.trim(),
        'address': address.value.trim(),
        'gender': gender.value,
        'birthDate': parsedDate.toUtc().toIso8601String(),
        'identifier': input,
        input.contains('@') ? 'email' : 'phone': normalizedIdentifier,
      };

      await _authRepository.registerUser(mapData);
      Get.to(
            () => const OtpScreen(),
        binding: OtpBinding(),
        arguments: {
          'identifier': normalizedIdentifier,
          'purpose': 'register',
          'password': password.value.trim(),
        },
      );
    } on RegistrationConflictException {
      Get.snackbar(
        'Registration unavailable',
        'An account with this email address or phone number already exists. '
            'Please try logging in or use different details.',
      );
    } on dio.DioException catch (error) {
      final message = error.response?.data is Map
          ? error.response?.data['message']?.toString()
          : null;
      Get.snackbar(
        'Registration failed',
        message?.trim().isNotEmpty == true
            ? message!
            : 'Unable to connect to the server. Please try again.',
      );
    } catch (error) {
      final message = error
          .toString()
          .replaceFirst(RegExp(r'^Exception:\s*'), '')
          .trim();
      Get.snackbar(
        'Registration failed',
        message.isEmpty ? 'Registration failed. Please try again.' : message,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String _formatPhone(String phone) {
    final normalized = phone.trim().replaceAll(' ', '');
    if (normalized.startsWith('0')) {
      return '+31${normalized.substring(1)}';
    }
    if (!normalized.startsWith('+')) {
      return '+31$normalized';
    }
    return normalized;
  }
}