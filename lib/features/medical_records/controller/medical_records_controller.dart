import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

import '../../auth/repository/auth_repository.dart';

class MedicalRecordController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  final AuthRepository _authRepo = AuthRepository();

  var isProfileLoading = false.obs;
  var completionRate = 0.0.obs;
  var bloodType = "غير محدد".obs;
  var height = "غير محدد".obs;
  var weight = "غير محدد".obs;
  var chronicDiseases = "لا يوجد".obs;
  var allergies = "لا يوجد".obs;
  var surgeries = "لا يوجد".obs;

  var isHistoryLoading = false.obs;
  var medicalHistories = [].obs;
  var currentPage = 1;
  final int limit = 20;
  var hasMoreHistories = true.obs;
  final ScrollController historyScrollController = ScrollController();

  var isAttachmentsLoading = false.obs;
  var attachments = [].obs;

  var isMedicinesLoading = false.obs;
  var myMedicines = [].obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);

    historyScrollController.addListener(() {
      if (historyScrollController.position.pixels ==
          historyScrollController.position.maxScrollExtent) {
        fetchNextHistoriesPage();
      }
    });

    fetchMedicalProfile();
    fetchMedicalHistories();
    fetchAttachments();
    fetchMyMedicines();
  }

  void fetchMedicalProfile() async {
    try {
      isProfileLoading.value = true;

      final data = await _authRepo.getMedicalProfileDetails();
      if (data != null) {
        bloodType.value = data['bloodType']?.toString() ?? "غير محدد";
        chronicDiseases.value = _parseToString(
          data['chronicDiseases'],
          "لا يوجد",
        );
        allergies.value = _parseToString(data['allergies'], "لا يوجد");
        surgeries.value = _parseToString(data['surgeries'], "لا يوجد");
      } else {
        bloodType.value = "غير محدد";
        chronicDiseases.value = "لا يوجد";
        allergies.value = "لا يوجد";
        surgeries.value = "لا يوجد";
      }

      final completion = await _authRepo.getProfileCompletionPercentage();
      completionRate.value = completion;
    } catch (e) {
      _showErrorSnackbar("فشل جلب الملف الطبي", e.toString());
    } finally {
      isProfileLoading.value = false;
    }
  }

  String _parseToString(dynamic value, String defaultValue) {
    if (value == null) return defaultValue;
    if (value is List) {
      if (value.isEmpty) return defaultValue;
      return value.join(', ');
    }
    return value.toString();
  }

  void fetchMedicalHistories() async {
    try {
      isHistoryLoading.value = true;
      currentPage = 1;
      hasMoreHistories.value = true;

      final data = await _authRepo.getMedicalHistories(
        page: currentPage,
        limit: limit,
      );

      medicalHistories.assignAll(data);
      if (data.length < limit) {
        hasMoreHistories.value = false;
      }
    } catch (e) {
      medicalHistories.clear();
      hasMoreHistories.value = false;
      _showErrorSnackbar("فشل جلب السجل المرضي", e.toString());
    } finally {
      isHistoryLoading.value = false;
    }
  }

  void fetchNextHistoriesPage() async {
    if (!hasMoreHistories.value || isHistoryLoading.value) return;

    try {
      currentPage++;
      final data = await _authRepo.getMedicalHistories(
        page: currentPage,
        limit: limit,
      );

      if (data.isEmpty) {
        hasMoreHistories.value = false;
      } else {
        medicalHistories.addAll(data);
        if (data.length < limit) {
          hasMoreHistories.value = false;
        }
      }
    } catch (e) {
      currentPage--;
      _showErrorSnackbar("فشل تحميل المزيد من الزيارات", e.toString());
    }
  }

  void fetchAttachments() async {
    try {
      isAttachmentsLoading.value = true;
      final dynamic response = await _authRepo.getMedicalAttachments();

      List<dynamic> allAttachments = [];

      if (response is Map<String, dynamic>) {
        if (response['profileAttachments'] is List) {
          allAttachments.addAll(response['profileAttachments']);
        }
        if (response['historyAttachments'] is List) {
          allAttachments.addAll(response['historyAttachments']);
        }
      } else if (response is List) {
        allAttachments = response;
      }

      attachments.assignAll(allAttachments);
      print("RAW ATTACHMENTS RESPONSE: $response");
    } catch (e) {
      attachments.clear();
    } finally {
      isAttachmentsLoading.value = false;
    }
  }

  void uploadAttachment() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
      );

      if (result != null && result.files.single.path != null) {
        String filePath = result.files.single.path!;

        String fileName = result.files.single.name;

        isAttachmentsLoading.value = true;

        await _authRepo.uploadMedicalAttachment(filePath, fileName);

        fetchAttachments();

        Get.snackbar(
          "نجاح",
          "تم رفع المرفق بنجاح",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          colorText: Colors.green,
        );
      }
    } catch (e) {
      _showErrorSnackbar("فشل رفع المرفق", e.toString());
    } finally {
      isAttachmentsLoading.value = false;
    }
  }

  void deleteAttachment(int attachmentId) async {
    try {
      await _authRepo.deleteMedicalAttachment(attachmentId);

      attachments.removeWhere(
        (item) => int.tryParse(item['id']?.toString() ?? '0') == attachmentId,
      );

      Get.snackbar(
        "نجاح",
        "تم حذف المرفق بنجاح",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "خطأ",
        "فشل حذف المرفق: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void fetchMyMedicines() async {
    try {
      isMedicinesLoading.value = true;
      final data = await _authRepo.getMyMedicines();
      myMedicines.assignAll(data);
    } catch (e) {
      myMedicines.clear();
      _showErrorSnackbar("فشل جلب الأدوية", e.toString());
    } finally {
      isMedicinesLoading.value = false;
    }
  }

  void updateProfileData(Map<String, dynamic> updatedData) async {
    try {
      isProfileLoading.value = true;
      await _authRepo.updateMedicalProfileMe(updatedData);

      fetchMedicalProfile();

      Get.snackbar(
        "نجاح",
        "تم تحديث الملف الطبي بنجاح",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        colorText: Colors.green,
      );
    } catch (e) {
      _showErrorSnackbar("فشل التحديث", e.toString());
    } finally {
      isProfileLoading.value = false;
    }
  }

  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
      colorText: Colors.red,
    );
  }

  @override
  void onClose() {
    tabController.dispose();
    historyScrollController.dispose();
    super.onClose();
  }
}
