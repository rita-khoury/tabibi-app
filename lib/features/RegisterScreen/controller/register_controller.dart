// import 'package:dio/dio.dart' as dio;
// import 'package:get/get.dart';
// import '../../OTP/binding/otp_binding.dart';
// import '../../auth/repository/auth_repository.dart';
// import '../../OTP/view/otp_screen.dart';
//
// class RegisterController extends GetxController {
//   final AuthRepository _authRepository = AuthRepository();
//
//   var isLoading = false.obs;
//
//   final emailOrPhone = ''.obs;
//   final password = ''.obs;
//   final firstName = ''.obs;
//   final fatherName = ''.obs;
//   final lastName = ''.obs;
//   final address = ''.obs;
//   final birthDate = ''.obs;
//   final gender = 'male'.obs;
//   final selectedCountry = Rx<dynamic>(null);
//
//   void setGender(String val) => gender.value = val.toLowerCase().trim();
//
//   void setBirthDate(String val) => birthDate.value = val;
//
//   void setPassword(String val) => password.value = val;
//
//   void setCountry(dynamic country) => selectedCountry.value = country;
//
//   Future<void> register() async {
//     if (firstName.value.isEmpty ||
//         fatherName.value.isEmpty ||
//         lastName.value.isEmpty ||
//         address.value.isEmpty ||
//         password.value.isEmpty ||
//         emailOrPhone.value.isEmpty) {
//       Get.snackbar("تنبيه", "يرجى تعبئة جميع الحقول الإلزامية");
//       return;
//     }
//
//     if (password.value.length < 8) {
//       Get.snackbar("تنبيه", "كلمة المرور يجب أن تكون 8 أحرف على الأقل");
//       return;
//     }
//
//     try {
//       isLoading.value = true;
//
//       final String input = emailOrPhone.value.trim();
//       final DateTime parsedDate = DateTime.parse(birthDate.value);
//       final String isoDate = parsedDate.toUtc().toIso8601String();
//
//       final Map<String, dynamic> mapData = {
//         "password": password.value.trim(),
//         "firstName": firstName.value.trim(),
//         "fatherName": fatherName.value.trim(),
//         "lastName": lastName.value.trim(),
//         "address": address.value.trim(),
//         "gender": gender.value,
//         "birthDate": isoDate,
//         "identifier": input,
//       };
//
//       if (input.contains("@")) {
//         mapData["email"] = input;
//       } else {
//         mapData["phone"] = _formatPhone(input);
//       }
//
//       print("Sending Register Data: $mapData");
//       await _authRepository.registerUser(mapData);
//
//       Get.to(
//         () => const OtpScreen(),
//         arguments: {'identifier': emailOrPhone.value.trim()},
//       );
//     } on dio.DioException catch (e) {
//       String errorMessage = "حدث خطأ غير معروف";
//       if (e.response?.data != null) {
//         final data = e.response!.data;
//         errorMessage = data is Map
//             ? (data['message'] ?? errorMessage)
//             : errorMessage;
//       } else {
//         errorMessage =
//             "تعذر الاتصال بالسيرفر. تأكد أن السيرفر يعمل على localhost:3000";
//       }
//       Get.snackbar("خطأ", errorMessage);
//     } catch (e) {
//       print("UNKNOWN ERROR => $e");
//       Get.snackbar("خطأ", "حدث خطأ داخلي");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   String _formatPhone(String phone) {
//     phone = phone.trim().replaceAll(' ', '');
//     if (phone.startsWith('0')) return '+31${phone.substring(1)}';
//     if (!phone.startsWith('+')) return '+31$phone';
//     return phone;
//   }
// }
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constance/api_constants.dart';
import '../../OTP/binding/otp_binding.dart';
import '../../auth/repository/auth_repository.dart';
import '../../OTP/view/otp_screen.dart';

class RegisterController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  var isLoading = false.obs;

  final emailOrPhone = ''.obs;
  final password = ''.obs;
  final firstName = ''.obs;
  final fatherName = ''.obs;
  final lastName = ''.obs;
  final address = ''.obs;
  final birthDate = ''.obs;
  final gender = 'male'.obs;
  final selectedCountry = Rx<dynamic>(null);

  // متغير الصورة لتستიدعيه في صفحة البروفايل لاحقاً
  final Rx<File?> selectedAvatarFile = Rx<File?>(null);

  void setGender(String val) => gender.value = val.toLowerCase().trim();

  void setBirthDate(String val) => birthDate.value = val;

  void setPassword(String val) => password.value = val;

  void setCountry(dynamic country) => selectedCountry.value = country;

  // دالة اختيار الصورة (يمكن استخدامها في صفحة تعديل الحساب لاحقاً)
  Future<void> pickAvatar(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: source,
      imageQuality: 70,
    );

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
      Get.snackbar("تنبيه", "يرجى تعبئة جميع الحقول الإلزامية");
      return;
    }

    if (password.value.length < 8) {
      Get.snackbar("تنبيه", "كلمة المرور يجب أن تكون 8 أحرف على الأقل");
      return;
    }

    try {
      isLoading.value = true;

      final String input = emailOrPhone.value.trim();
      final DateTime parsedDate = DateTime.parse(birthDate.value);
      final String isoDate = parsedDate.toUtc().toIso8601String();

      final Map<String, dynamic> mapData = {
        "password": password.value.trim(),
        "firstName": firstName.value.trim(),
        "fatherName": fatherName.value.trim(),
        "lastName": lastName.value.trim(),
        "address": address.value.trim(),
        "gender": gender.value,
        "birthDate": isoDate,
        "identifier": input,
      };

      if (input.contains("@")) {
        mapData["email"] = input;
      } else {
        mapData["phone"] = _formatPhone(input);
      }
      // عاد كما كان تماماً يقبل Map بدون أي أخطاء
      await _authRepository.registerUser(mapData);

      Get.to(
        () => const OtpScreen(),
        binding: OtpBinding(),
        arguments: {
          'identifier': input.contains('@') ? input : _formatPhone(input),
          'purpose': 'register',
          'password': password.value.trim(),
        },
      );
    } on dio.DioException catch (e) {
      String errorMessage = "حدث خطأ غير معروف";
      if (e.response?.data != null) {
        final data = e.response!.data;
        errorMessage = data is Map
            ? (data['message'] ?? errorMessage)
            : errorMessage;
      } else {
        errorMessage =
        "تعذر الاتصال بالسيرفر. تأكد أن السيرفر يعمل على ${ApiConstants.baseUrl}";
      }
      Get.snackbar("خطأ", errorMessage);
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ داخلي");
    } finally {
      isLoading.value = false;
    }
  }

  String _formatPhone(String phone) {
    phone = phone.trim().replaceAll(' ', '');
    if (phone.startsWith('0')) return '+31${phone.substring(1)}';
    if (!phone.startsWith('+')) return '+31$phone';
    return phone;
  }
}