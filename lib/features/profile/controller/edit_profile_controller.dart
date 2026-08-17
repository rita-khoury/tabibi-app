// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart' hide FormData, MultipartFile;
// import 'package:image_picker/image_picker.dart';
// import 'package:tabibi/features/profile/controller/profile_controller.dart';
// import '../../auth/repository/auth_repository.dart';
//
// class EditProfileController extends GetxController {
//   final AuthRepository _authRepository = Get.find<AuthRepository>();
//
//   late TextEditingController firstNameController;
//   late TextEditingController lastNameController;
//   late TextEditingController emailController;
//   late TextEditingController phoneController;
//   late TextEditingController addressController;
//   late TextEditingController occupationController;
//   late TextEditingController emergencyNameController;
//   late TextEditingController emergencyPhoneController;
//
//   late TextEditingController currentPasswordController;
//   late TextEditingController newPasswordController;
//   late TextEditingController confirmPasswordController;
//
//   var selectedMaritalStatus = 'Married'.obs;
//   var isCurrentPasswordObscure = true.obs;
//   var isNewPasswordObscure = true.obs;
//   var isConfirmPasswordObscure = true.obs;
//
//   final _picker = ImagePicker();
//   Rx<File?> profileImage = Rx<File?>(null);
//   RxString currentAvatarUrl = "".obs;
//
//   RxBool isProfileLoading = false.obs;
//   RxBool isPasswordLoading = false.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     firstNameController = TextEditingController();
//     lastNameController = TextEditingController();
//     emailController = TextEditingController();
//     phoneController = TextEditingController();
//     addressController = TextEditingController();
//     occupationController = TextEditingController();
//     emergencyNameController = TextEditingController();
//     emergencyPhoneController = TextEditingController();
//     currentPasswordController = TextEditingController();
//     newPasswordController = TextEditingController();
//     confirmPasswordController = TextEditingController();
//
//     fillCurrentUserData();
//   }
//
//   void fillCurrentUserData() {
//     if (Get.isRegistered<ProfileController>()) {
//       final userProfile = Get.find<ProfileController>().profile.value;
//       if (userProfile != null) {
//         firstNameController.text = userProfile.firstName;
//         lastNameController.text = userProfile.lastName;
//         emailController.text = userProfile.email;
//         phoneController.text = userProfile.phone ?? "";
//         addressController.text = userProfile.address;
//         currentAvatarUrl.value = userProfile.avatarUrl ?? "";
//
//         if (userProfile.patientProfile != null) {
//           final patient = userProfile.patientProfile!;
//           occupationController.text = patient.occupation ?? "";
//           emergencyNameController.text = patient.emergencyContactName ?? "";
//           emergencyPhoneController.text = patient.emergencyContactPhone ?? "";
//           if (patient.maritalStatus != null &&
//               patient.maritalStatus!.isNotEmpty) {
//             selectedMaritalStatus.value =
//                 patient.maritalStatus!.capitalizeFirst ?? "Married";
//           }
//         }
//       }
//     }
//   }
//
//   Future<void> pickImage() async {
//     try {
//       final XFile? image = await _picker.pickImage(
//         source: ImageSource.gallery,
//         imageQuality: 80,
//       );
//       if (image != null) {
//         profileImage.value = File(image.path);
//         String fileName = image.path.split('/').last;
//         FormData formData = FormData.fromMap({
//           'file': await MultipartFile.fromFile(image.path, filename: fileName),
//         });
//
//         Get.dialog(
//           const Center(child: CircularProgressIndicator()),
//           barrierDismissible: false,
//         );
//         final response = await _authRepository.dio.patch(
//           '/users/me/avatar',
//           data: formData,
//         );
//         Get.back();
//
//         if (response.statusCode == 200 || response.statusCode == 201) {
//           if (Get.isRegistered<ProfileController>()) {
//             Get.find<ProfileController>().fetchProfile("1");
//           }
//           Get.snackbar('Success', 'Profile picture updated successfully');
//         }
//       }
//     } catch (e) {
//       if (Get.isDialogOpen == true) Get.back();
//       _showErrorSnackBar(e);
//     }
//   }
//
//   Future<void> deletePhoto() async {
//     try {
//       final response = await _authRepository.dio.delete('/users/me/avatar');
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         profileImage.value = null;
//         currentAvatarUrl.value = "";
//         if (Get.isRegistered<ProfileController>()) {
//           Get.find<ProfileController>().fetchProfile("1");
//         }
//         Get.snackbar('Deleted', 'Photo removed successfully');
//       }
//     } catch (e) {
//       _showErrorSnackBar(e);
//     }
//   }
//
//   Future<void> saveChanges() async {
//     try {
//       isProfileLoading.value = true;
//       String userId = "1";
//       if (Get.isRegistered<ProfileController>()) {
//         final userProfile = Get.find<ProfileController>().profile.value;
//         if (userProfile != null) userId = userProfile.id.toString();
//       }
//
//       Map<String, dynamic> userUpdateBody = {
//         "firstName": firstNameController.text,
//         "lastName": lastNameController.text,
//         "address": addressController.text,
//       };
//
//       await _authRepository.dio.patch('/users/$userId', data: userUpdateBody);
//
//       Map<String, dynamic> patientUpdateBody = {
//         "maritalStatus": selectedMaritalStatus.value.toLowerCase(),
//         "occupation": occupationController.text,
//         "emergencyContactName": emergencyNameController.text,
//         "emergencyContactPhone": emergencyPhoneController.text,
//       };
//
//       await _authRepository.dio.patch(
//         '/patients/profile',
//         data: patientUpdateBody,
//       );
//
//       if (Get.isRegistered<ProfileController>()) {
//         await Get.find<ProfileController>().fetchProfile(userId);
//       }
//
//       Get.snackbar(
//         'Success',
//         'Profile updated successfully',
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );
//     } catch (e) {
//       _showErrorSnackBar(e);
//     } finally {
//       isProfileLoading.value = false;
//     }
//   }
//
//   Future<void> changePassword() async {
//     if (newPasswordController.text != confirmPasswordController.text) {
//       Get.snackbar('Error', 'New passwords do not match');
//       return;
//     }
//
//     try {
//       isPasswordLoading.value = true;
//       Map<String, dynamic> passwordBody = {
//         "oldPassword": currentPasswordController.text,
//         "newPassword": newPasswordController.text,
//       };
//
//       final response = await _authRepository.dio.post(
//         '/auth/change-password',
//         data: passwordBody,
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         currentPasswordController.clear();
//         newPasswordController.clear();
//         confirmPasswordController.clear();
//         Get.snackbar(
//           'Success',
//           'Password changed successfully',
//           backgroundColor: Colors.blue,
//           colorText: Colors.white,
//         );
//       }
//     } catch (e) {
//       _showErrorSnackBar(e);
//     } finally {
//       isPasswordLoading.value = false;
//     }
//   }
//
//   void _showErrorSnackBar(dynamic error) {
//     String errorMsg = "Connection error";
//     if (error is DioException && error.response != null) {
//       errorMsg = error.response?.data['message'] ?? errorMsg;
//     }
//     Get.snackbar(
//       'Error',
//       errorMsg,
//       backgroundColor: Colors.redAccent,
//       colorText: Colors.white,
//     );
//   }
//
//   @override
//   void onClose() {
//     firstNameController.dispose();
//     lastNameController.dispose();
//     emailController.dispose();
//     phoneController.dispose();
//     addressController.dispose();
//     occupationController.dispose();
//     emergencyNameController.dispose();
//     emergencyPhoneController.dispose();
//     currentPasswordController.dispose();
//     newPasswordController.dispose();
//     confirmPasswordController.dispose();
//     super.onClose();
//   }
// }


import '../../../core/constance/api_constants.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:tabibi/features/profile/controller/profile_controller.dart';
import '../../auth/repository/auth_repository.dart';

class EditProfileController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController occupationController;
  late TextEditingController emergencyNameController;
  late TextEditingController emergencyPhoneController;

  late TextEditingController currentPasswordController;
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;

  var selectedMaritalStatus = 'Married'.obs;
  var isCurrentPasswordObscure = true.obs;
  var isNewPasswordObscure = true.obs;
  var isConfirmPasswordObscure = true.obs;

  final _picker = ImagePicker();
  Rx<File?> profileImage = Rx<File?>(null);
  RxString currentAvatarUrl = "".obs;

  RxBool isProfileLoading = false.obs;
  RxBool isPasswordLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();
    occupationController = TextEditingController();
    emergencyNameController = TextEditingController();
    emergencyPhoneController = TextEditingController();
    currentPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    fillCurrentUserData();
  }

  void fillCurrentUserData() {
    if (Get.isRegistered<ProfileController>()) {
      final userProfile = Get.find<ProfileController>().profile.value;
      if (userProfile != null) {
        firstNameController.text = userProfile.firstName;
        lastNameController.text = userProfile.lastName;
        emailController.text = userProfile.email;
        phoneController.text = userProfile.phone ?? "";
        addressController.text = userProfile.address;
        currentAvatarUrl.value = ApiConstants.getFullImageUrl(userProfile.avatarUrl);

        if (userProfile.patientProfile != null) {
          final patient = userProfile.patientProfile!;
          occupationController.text = patient.occupation ?? "";
          emergencyNameController.text = patient.emergencyContactName ?? "";
          emergencyPhoneController.text = patient.emergencyContactPhone ?? "";
          if (patient.maritalStatus != null &&
              patient.maritalStatus!.isNotEmpty) {
            selectedMaritalStatus.value =
                patient.maritalStatus!.capitalizeFirst ?? "Married";
          }
        }
      }
    }
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        profileImage.value = File(image.path);
        String fileName = image.path.split('/').last;
        FormData formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(image.path, filename: fileName),
        });

        Get.dialog(
          const Center(child: CircularProgressIndicator()),
          barrierDismissible: false,
        );
        final response = await _authRepository.dio.patch(
          '/users/me/avatar',
          data: formData,
        );
        Get.back();

        if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = response.data;
        final avatarPayload = responseBody is Map && responseBody['data'] is Map
            ? responseBody['data'] as Map
            : responseBody;
        final uploadedAvatar = avatarPayload is Map
            ? (avatarPayload['avatarUrl'] ?? avatarPayload['avatar'] ?? avatarPayload['image'])
            : null;
        if (uploadedAvatar != null) {
          currentAvatarUrl.value =
              ApiConstants.getFullImageUrl(uploadedAvatar.toString());
        }
          if (Get.isRegistered<ProfileController>()) {
            // تحديث بيانات البروفايل تلقائياً بعد تغيير الصورة
            String userId = Get.find<ProfileController>().profile.value?.id.toString() ?? "1";
            Get.find<ProfileController>().fetchProfile(userId);
          }
          Get.snackbar(
            'Success',
            'Profile picture updated successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      _showErrorSnackBar(e);
    }
  }

  Future<void> deletePhoto() async {
    try {
      final response = await _authRepository.dio.delete('/users/me/avatar');
      if (response.statusCode == 200 || response.statusCode == 201) {
        profileImage.value = null;
        currentAvatarUrl.value = "";
        if (Get.isRegistered<ProfileController>()) {
          String userId = Get.find<ProfileController>().profile.value?.id.toString() ?? "1";
          Get.find<ProfileController>().fetchProfile(userId);
        }
        Get.snackbar(
          'Deleted',
          'Photo removed successfully',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      _showErrorSnackBar(e);
    }
  }

  Future<void> saveChanges() async {
    try {
      isProfileLoading.value = true;
      String userId = "1";
      if (Get.isRegistered<ProfileController>()) {
        final userProfile = Get.find<ProfileController>().profile.value;
        if (userProfile != null) userId = userProfile.id.toString();
      }

      Map<String, dynamic> userUpdateBody = {
        "firstName": firstNameController.text,
        "lastName": lastNameController.text,
        "address": addressController.text,
      };

      await _authRepository.dio.patch('/users/$userId', data: userUpdateBody);

      Map<String, dynamic> patientUpdateBody = {
        "maritalStatus": selectedMaritalStatus.value.toLowerCase(),
        "occupation": occupationController.text,
        "emergencyContactName": emergencyNameController.text,
        "emergencyContactPhone": emergencyPhoneController.text,
      };

      await _authRepository.dio.patch(
        '/patients/profile',
        data: patientUpdateBody,
      );

      if (Get.isRegistered<ProfileController>()) {
        await Get.find<ProfileController>().fetchProfile(userId);
      }

      Get.snackbar(
        'Success',
        'Profile updated successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      _showErrorSnackBar(e);
    } finally {
      isProfileLoading.value = false;
    }
  }

  Future<void> changePassword() async {
    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'New passwords do not match',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isPasswordLoading.value = true;
      Map<String, dynamic> passwordBody = {
        "oldPassword": currentPasswordController.text,
        "newPassword": newPasswordController.text,
      };

      final response = await _authRepository.dio.post(
        '/auth/change-password',
        data: passwordBody,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
        Get.snackbar(
          'Success',
          'Password changed successfully',
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      _showErrorSnackBar(e);
    } finally {
      isPasswordLoading.value = false;
    }
  }

  void _showErrorSnackBar(dynamic error) {
    String errorMsg = "Connection error";
    if (error is DioException && error.response != null) {
      errorMsg = error.response?.data['message'] ?? errorMsg;
    }
    Get.snackbar(
      'Error',
      errorMsg,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    occupationController.dispose();
    emergencyNameController.dispose();
    emergencyPhoneController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
