import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController {
  // ================= TEXT CONTROLLERS =================
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  // ================= IMAGE =================
  RxString imageUrl = "".obs; // from API
  Rx<File?> imageFile = Rx<File?>(null); // from gallery

  final ImagePicker picker = ImagePicker();

  // ================= STATE =================
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    // بيانات تجريبية (بدل API لاحقًا)
    nameController.text = "";
    emailController.text = "";
    imageUrl.value = "";
  }

  // ================= PICK IMAGE =================
  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      imageFile.value = File(picked.path);
    }
  }

  // ================= UPDATE PROFILE =================
  Future<void> updateProfile() async {
    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;

    Get.snackbar(
      "Success",
      "Profile updated successfully",
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    super.onClose();
  }
}