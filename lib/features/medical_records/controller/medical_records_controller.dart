// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:dio/dio.dart';
// // import 'package:file_picker/file_picker.dart';
// //
// // import '../../auth/repository/auth_repository.dart';
// //
// // class MedicalRecordController extends GetxController
// //     with GetSingleTickerProviderStateMixin {
// //   late TabController tabController;
// //
// //   final AuthRepository _authRepo = AuthRepository();
// //
// //   var isProfileLoading = false.obs;
// //   var completionRate = 0.0.obs;
// //   var bloodType = "غير محدد".obs;
// //   var height = "غير محدد".obs;
// //   var weight = "غير محدد".obs;
// //   var chronicDiseases = "لا يوجد".obs;
// //   var allergies = "لا يوجد".obs;
// //   var surgeries = "لا يوجد".obs;
// //
// //   var isHistoryLoading = false.obs;
// //   var medicalHistories = [].obs;
// //   var currentPage = 1;
// //   final int limit = 20;
// //   var hasMoreHistories = true.obs;
// //   final ScrollController historyScrollController = ScrollController();
// //
// //   var isAttachmentsLoading = false.obs;
// //   var attachments = [].obs;
// //
// //   var isMedicinesLoading = false.obs;
// //   var myMedicines = [].obs;
// //
// //   @override
// //   void onInit() {
// //     super.onInit();
// //     tabController = TabController(length: 3, vsync: this);
// //
// //     historyScrollController.addListener(() {
// //       if (historyScrollController.position.pixels ==
// //           historyScrollController.position.maxScrollExtent) {
// //         fetchNextHistoriesPage();
// //       }
// //     });
// //
// //     fetchMedicalProfile();
// //     fetchMedicalHistories();
// //     fetchAttachments();
// //     fetchMyMedicines();
// //   }
// //
// //   void fetchMedicalProfile() async {
// //     try {
// //       isProfileLoading.value = true;
// //
// //       final data = await _authRepo.getMedicalProfileDetails();
// //       if (data != null) {
// //         bloodType.value = data['bloodType']?.toString() ?? "غير محدد";
// //         chronicDiseases.value = _parseToString(
// //           data['chronicDiseases'],
// //           "لا يوجد",
// //         );
// //         allergies.value = _parseToString(data['allergies'], "لا يوجد");
// //         surgeries.value = _parseToString(data['surgeries'], "لا يوجد");
// //       } else {
// //         bloodType.value = "غير محدد";
// //         chronicDiseases.value = "لا يوجد";
// //         allergies.value = "لا يوجد";
// //         surgeries.value = "لا يوجد";
// //       }
// //
// //       final completion = await _authRepo.getProfileCompletionPercentage();
// //       completionRate.value = completion;
// //     } catch (e) {
// //       _showErrorSnackbar("فشل جلب الملف الطبي", e.toString());
// //     } finally {
// //       isProfileLoading.value = false;
// //     }
// //   }
// //
// //   String _parseToString(dynamic value, String defaultValue) {
// //     if (value == null) return defaultValue;
// //     if (value is List) {
// //       if (value.isEmpty) return defaultValue;
// //       return value.join(', ');
// //     }
// //     return value.toString();
// //   }
// //
// //   void fetchMedicalHistories() async {
// //     try {
// //       isHistoryLoading.value = true;
// //       currentPage = 1;
// //       hasMoreHistories.value = true;
// //
// //       final data = await _authRepo.getMedicalHistories(
// //         page: currentPage,
// //         limit: limit,
// //       );
// //
// //       medicalHistories.assignAll(data);
// //       if (data.length < limit) {
// //         hasMoreHistories.value = false;
// //       }
// //     } catch (e) {
// //       medicalHistories.clear();
// //       hasMoreHistories.value = false;
// //       _showErrorSnackbar("فشل جلب السجل المرضي", e.toString());
// //     } finally {
// //       isHistoryLoading.value = false;
// //     }
// //   }
// //
// //   void fetchNextHistoriesPage() async {
// //     if (!hasMoreHistories.value || isHistoryLoading.value) return;
// //
// //     try {
// //       currentPage++;
// //       final data = await _authRepo.getMedicalHistories(
// //         page: currentPage,
// //         limit: limit,
// //       );
// //
// //       if (data.isEmpty) {
// //         hasMoreHistories.value = false;
// //       } else {
// //         medicalHistories.addAll(data);
// //         if (data.length < limit) {
// //           hasMoreHistories.value = false;
// //         }
// //       }
// //     } catch (e) {
// //       currentPage--;
// //       _showErrorSnackbar("فشل تحميل المزيد من الزيارات", e.toString());
// //     }
// //   }
// //
// //   void fetchAttachments() async {
// //     try {
// //       isAttachmentsLoading.value = true;
// //       final dynamic response = await _authRepo.getMedicalAttachments();
// //
// //       List<dynamic> allAttachments = [];
// //
// //       if (response is Map<String, dynamic>) {
// //         if (response['profileAttachments'] is List) {
// //           allAttachments.addAll(response['profileAttachments']);
// //         }
// //         if (response['historyAttachments'] is List) {
// //           allAttachments.addAll(response['historyAttachments']);
// //         }
// //       } else if (response is List) {
// //         allAttachments = response;
// //       }
// //
// //       attachments.assignAll(allAttachments);
// //       print("RAW ATTACHMENTS RESPONSE: $response");
// //     } catch (e) {
// //       attachments.clear();
// //     } finally {
// //       isAttachmentsLoading.value = false;
// //     }
// //   }
// //
// //   void uploadAttachment() async {
// //     try {
// //       FilePickerResult? result = await FilePicker.platform.pickFiles(
// //         type: FileType.custom,
// //         allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
// //       );
// //
// //       if (result != null && result.files.single.path != null) {
// //         String filePath = result.files.single.path!;
// //
// //         String fileName = result.files.single.name;
// //
// //         isAttachmentsLoading.value = true;
// //
// //         await _authRepo.uploadMedicalAttachment(filePath, fileName);
// //
// //         fetchAttachments();
// //
// //         Get.snackbar(
// //           "نجاح",
// //           "تم رفع المرفق بنجاح",
// //           snackPosition: SnackPosition.BOTTOM,
// //           backgroundColor: Colors.green.withValues(alpha: 0.1),
// //           colorText: Colors.green,
// //         );
// //       }
// //     } catch (e) {
// //       _showErrorSnackbar("فشل رفع المرفق", e.toString());
// //     } finally {
// //       isAttachmentsLoading.value = false;
// //     }
// //   }
// //
// //   void deleteAttachment(int attachmentId) async {
// //     try {
// //       await _authRepo.deleteMedicalAttachment(attachmentId);
// //
// //       attachments.removeWhere(
// //         (item) => int.tryParse(item['id']?.toString() ?? '0') == attachmentId,
// //       );
// //
// //       Get.snackbar(
// //         "نجاح",
// //         "تم حذف المرفق بنجاح",
// //         snackPosition: SnackPosition.BOTTOM,
// //       );
// //     } catch (e) {
// //       Get.snackbar(
// //         "خطأ",
// //         "فشل حذف المرفق: $e",
// //         snackPosition: SnackPosition.BOTTOM,
// //       );
// //     }
// //   }
// //
// //   void fetchMyMedicines() async {
// //     try {
// //       isMedicinesLoading.value = true;
// //       final data = await _authRepo.getMyMedicines();
// //       myMedicines.assignAll(data);
// //     } catch (e) {
// //       myMedicines.clear();
// //       _showErrorSnackbar("فشل جلب الأدوية", e.toString());
// //     } finally {
// //       isMedicinesLoading.value = false;
// //     }
// //   }
// //
// //   void updateProfileData(Map<String, dynamic> updatedData) async {
// //     try {
// //       isProfileLoading.value = true;
// //       await _authRepo.updateMedicalProfileMe(updatedData);
// //
// //       fetchMedicalProfile();
// //
// //       Get.snackbar(
// //         "نجاح",
// //         "تم تحديث الملف الطبي بنجاح",
// //         snackPosition: SnackPosition.BOTTOM,
// //         backgroundColor: Colors.green.withValues(alpha: 0.1),
// //         colorText: Colors.green,
// //       );
// //     } catch (e) {
// //       _showErrorSnackbar("فشل التحديث", e.toString());
// //     } finally {
// //       isProfileLoading.value = false;
// //     }
// //   }
// //
// //   void _showErrorSnackbar(String title, String message) {
// //     Get.snackbar(
// //       title,
// //       message,
// //       snackPosition: SnackPosition.BOTTOM,
// //       backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
// //       colorText: Colors.red,
// //     );
// //   }
// //
// //   @override
// //   void onClose() {
// //     tabController.dispose();
// //     historyScrollController.dispose();
// //     super.onClose();
// //   }
// // }
//
// //
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:dio/dio.dart';
// // import 'package:file_picker/file_picker.dart';
// //
// // import '../../../core/constance/app_messages.dart';
// // import '../../auth/repository/auth_repository.dart';
// //
// // class MedicalRecordController extends GetxController
// //     with GetSingleTickerProviderStateMixin {
// //   late TabController tabController;
// //
// //   final AuthRepository _authRepo = AuthRepository();
// //
// //   var isProfileLoading = false.obs;
// //   var completionRate = 0.0.obs;
// //   var bloodType = AppMessages.undefinedValue.obs;
// //   var height = AppMessages.undefinedValue.obs;
// //   var weight = AppMessages.undefinedValue.obs;
// //   var chronicDiseases = AppMessages.noneValue.obs;
// //   var allergies = AppMessages.noneValue.obs;
// //   var surgeries = AppMessages.noneValue.obs;
// //
// //   var isHistoryLoading = false.obs;
// //   var medicalHistories = [].obs;
// //   var currentPage = 1;
// //   final int limit = 20;
// //   var hasMoreHistories = true.obs;
// //   final ScrollController historyScrollController = ScrollController();
// //
// //   var isAttachmentsLoading = false.obs;
// //   var attachments = [].obs;
// //
// //   var isMedicinesLoading = false.obs;
// //   var myMedicines = [].obs;
// //
// //   @override
// //   void onInit() {
// //     super.onInit();
// //     tabController = TabController(length: 3, vsync: this);
// //
// //     historyScrollController.addListener(() {
// //       if (historyScrollController.position.pixels ==
// //           historyScrollController.position.maxScrollExtent) {
// //         fetchNextHistoriesPage();
// //       }
// //     });
// //
// //     fetchMedicalProfile();
// //     fetchMedicalHistories();
// //     fetchAttachments();
// //     fetchMyMedicines();
// //   }
// //
// //   void fetchMedicalProfile() async {
// //     try {
// //       isProfileLoading.value = true;
// //
// //       final data = await _authRepo.getMedicalProfileDetails();
// //       if (data != null) {
// //         bloodType.value = data['bloodType']?.toString() ?? AppMessages.undefinedValue;
// //         chronicDiseases.value = _parseToString(
// //           data['chronicDiseases'],
// //           AppMessages.noneValue,
// //         );
// //         allergies.value = _parseToString(data['allergies'], AppMessages.noneValue);
// //         surgeries.value = _parseToString(data['surgeries'], AppMessages.noneValue);
// //       } else {
// //         bloodType.value = AppMessages.undefinedValue;
// //         chronicDiseases.value = AppMessages.noneValue;
// //         allergies.value = AppMessages.noneValue;
// //         surgeries.value = AppMessages.noneValue;
// //       }
// //
// //       final completion = await _authRepo.getProfileCompletionPercentage();
// //       completionRate.value = completion;
// //     } catch (e) {
// //       _showErrorSnackbar(AppMessages.fetchProfileError, e.toString());
// //     } finally {
// //       isProfileLoading.value = false;
// //     }
// //   }
// //
// //   String _parseToString(dynamic value, String defaultValue) {
// //     if (value == null) return defaultValue;
// //     if (value is List) {
// //       if (value.isEmpty) return defaultValue;
// //       return value.join(', ');
// //     }
// //     return value.toString();
// //   }
// //
// //   void fetchMedicalHistories() async {
// //     try {
// //       isHistoryLoading.value = true;
// //       currentPage = 1;
// //       hasMoreHistories.value = true;
// //
// //       final data = await _authRepo.getMedicalHistories(
// //         page: currentPage,
// //         limit: limit,
// //       );
// //
// //       medicalHistories.assignAll(data);
// //       if (data.length < limit) {
// //         hasMoreHistories.value = false;
// //       }
// //     } catch (e) {
// //       medicalHistories.clear();
// //       hasMoreHistories.value = false;
// //       _showErrorSnackbar(AppMessages.fetchHistoryError, e.toString());
// //     } finally {
// //       isHistoryLoading.value = false;
// //     }
// //   }
// //
// //   void fetchNextHistoriesPage() async {
// //     if (!hasMoreHistories.value || isHistoryLoading.value) return;
// //
// //     try {
// //       currentPage++;
// //       final data = await _authRepo.getMedicalHistories(
// //         page: currentPage,
// //         limit: limit,
// //       );
// //
// //       if (data.isEmpty) {
// //         hasMoreHistories.value = false;
// //       } else {
// //         medicalHistories.addAll(data);
// //         if (data.length < limit) {
// //           hasMoreHistories.value = false;
// //         }
// //       }
// //     } catch (e) {
// //       currentPage--;
// //       _showErrorSnackbar(AppMessages.fetchMoreHistoryError, e.toString());
// //     }
// //   }
// //
// //   void fetchAttachments() async {
// //     try {
// //       isAttachmentsLoading.value = true;
// //       final dynamic response = await _authRepo.getMedicalAttachments();
// //
// //       List<dynamic> allAttachments = [];
// //
// //       if (response is Map<String, dynamic>) {
// //         if (response['profileAttachments'] is List) {
// //           allAttachments.addAll(response['profileAttachments']);
// //         }
// //         if (response['historyAttachments'] is List) {
// //           allAttachments.addAll(response['historyAttachments']);
// //         }
// //       } else if (response is List) {
// //         allAttachments = response;
// //       }
// //
// //       attachments.assignAll(allAttachments);
// //       print("RAW ATTACHMENTS RESPONSE: $response");
// //     } catch (e) {
// //       attachments.clear();
// //     } finally {
// //       isAttachmentsLoading.value = false;
// //     }
// //   }
// //
// //   void uploadAttachment() async {
// //     try {
// //       FilePickerResult? result = await FilePicker.pickFiles(
// //         type: FileType.custom,
// //         allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
// //       );
// //
// //       if (result != null && result.files.single.path != null) {
// //         String filePath = result.files.single.path!;
// //         String fileName = result.files.single.name;
// //
// //         isAttachmentsLoading.value = true;
// //
// //         await _authRepo.uploadMedicalAttachment(filePath, fileName);
// //
// //         fetchAttachments();
// //
// //         Get.snackbar(
// //           AppMessages.successTitle,
// //           AppMessages.uploadAttachmentSuccess,
// //           snackPosition: SnackPosition.BOTTOM,
// //           backgroundColor: Colors.green.withValues(alpha: 0.1),
// //           colorText: Colors.green,
// //         );
// //       }
// //     } catch (e) {
// //       _showErrorSnackbar(AppMessages.uploadAttachmentError, e.toString());
// //     } finally {
// //       isAttachmentsLoading.value = false;
// //     }
// //   }
// //
// //   void deleteAttachment(int attachmentId) async {
// //     try {
// //       await _authRepo.deleteMedicalAttachment(attachmentId);
// //
// //       attachments.removeWhere(
// //             (item) => int.tryParse(item['id']?.toString() ?? '0') == attachmentId,
// //       );
// //
// //       Get.snackbar(
// //         AppMessages.successTitle,
// //         AppMessages.deleteAttachmentSuccess,
// //         snackPosition: SnackPosition.BOTTOM,
// //       );
// //     } catch (e) {
// //       Get.snackbar(
// //         AppMessages.errorTitle,
// //         "${AppMessages.deleteAttachmentError}$e",
// //         snackPosition: SnackPosition.BOTTOM,
// //       );
// //     }
// //   }
// //
// //   void fetchMyMedicines() async {
// //     try {
// //       isMedicinesLoading.value = true;
// //       final data = await _authRepo.getMyMedicines();
// //       myMedicines.assignAll(data);
// //     } catch (e) {
// //       myMedicines.clear();
// //       _showErrorSnackbar(AppMessages.fetchMedicinesError, e.toString());
// //     } finally {
// //       isMedicinesLoading.value = false;
// //     }
// //   }
// //
// //   void updateProfileData(Map<String, dynamic> updatedData) async {
// //     try {
// //       isProfileLoading.value = true;
// //       await _authRepo.updateMedicalProfileMe(updatedData);
// //
// //       fetchMedicalProfile();
// //
// //       Get.snackbar(
// //         AppMessages.successTitle,
// //         AppMessages.updateProfileSuccess,
// //         snackPosition: SnackPosition.BOTTOM,
// //         backgroundColor: Colors.green.withValues(alpha: 0.1),
// //         colorText: Colors.green,
// //       );
// //     } catch (e) {
// //       _showErrorSnackbar(AppMessages.updateProfileError, e.toString());
// //     } finally {
// //       isProfileLoading.value = false;
// //     }
// //   }
// //
// //   void _showErrorSnackbar(String title, String message) {
// //     Get.snackbar(
// //       title,
// //       message,
// //       snackPosition: SnackPosition.BOTTOM,
// //       backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
// //       colorText: Colors.red,
// //     );
// //   }
// //
// //   @override
// //   void onClose() {
// //     tabController.dispose();
// //     historyScrollController.dispose();
// //     super.onClose();
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:dio/dio.dart';
// import 'package:file_selector/file_selector.dart';
//
// import '../../auth/repository/auth_repository.dart';
//
// class MedicalRecordController extends GetxController
// with GetSingleTickerProviderStateMixin {
// late TabController tabController;
//
// final AuthRepository _authRepo = AuthRepository();
//
// // ==================== Medical Profile ====================
//
// var isProfileLoading = false.obs;
// var completionRate = 0.0.obs;
// var bloodType = "غير محدد".obs;
// var height = "غير محدد".obs;
// var weight = "غير محدد".obs;
// var chronicDiseases = "لا يوجد".obs;
// var allergies = "لا يوجد".obs;
// var surgeries = "لا يوجد".obs;
//
// // ==================== Medical History ====================
//
// var isHistoryLoading = false.obs;
// var medicalHistories = [].obs;
//
// var currentPage = 1;
// final int limit = 20;
// var hasMoreHistories = true.obs;
//
// final ScrollController historyScrollController =
// ScrollController();
//
// // ==================== Attachments ====================
//
// var isAttachmentsLoading = false.obs;
// var attachments = [].obs;
//
// // ==================== Medicines ====================
//
// var isMedicinesLoading = false.obs;
// var myMedicines = [].obs;
//
// // ==================== Lifecycle ====================
//
// @override
// void onInit() {
// super.onInit();
//
// tabController = TabController(
// length: 3,
// vsync: this,
// );
//
// historyScrollController.addListener(() {
// if (historyScrollController.position.pixels >=
// historyScrollController.position.maxScrollExtent) {
// fetchNextHistoriesPage();
// }
// });
//
// fetchMedicalProfile();
// fetchMedicalHistories();
// fetchAttachments();
// fetchMyMedicines();
// }
//
// // ==================== Medical Profile ====================
//
// Future<void> fetchMedicalProfile() async {
// try {
// isProfileLoading.value = true;
//
// final data = await _authRepo.getMedicalProfileDetails();
//
// if (data != null) {
// bloodType.value =
// data['bloodType']?.toString() ?? "غير محدد";
//
// chronicDiseases.value = _parseToString(
// data['chronicDiseases'],
// "لا يوجد",
// );
//
// allergies.value = _parseToString(
// data['allergies'],
// "لا يوجد",
// );
//
// surgeries.value = _parseToString(
// data['surgeries'],
// "لا يوجد",
// );
//
// height.value = data['height']?.toString() ?? "غير محدد";
//
// weight.value = data['weight']?.toString() ?? "غير محدد";
// } else {
// bloodType.value = "غير محدد";
// height.value = "غير محدد";
// weight.value = "غير محدد";
// chronicDiseases.value = "لا يوجد";
// allergies.value = "لا يوجد";
// surgeries.value = "لا يوجد";
// }
//
// final completion =
// await _authRepo.getProfileCompletionPercentage();
//
// completionRate.value = completion;
// } catch (e) {
// _showErrorSnackbar(
// "فشل جلب الملف الطبي",
// e.toString(),
// );
// } finally {
// isProfileLoading.value = false;
// }
// }
//
// String _parseToString(
// dynamic value,
// String defaultValue,
// ) {
// if (value == null) {
// return defaultValue;
// }
//
// if (value is List) {
// if (value.isEmpty) {
// return defaultValue;
// }
//
// return value.join(', ');
// }
//
// return value.toString();
// }
//
// // ==================== Medical History ====================
//
// Future<void> fetchMedicalHistories() async {
// try {
// isHistoryLoading.value = true;
//
// currentPage = 1;
// hasMoreHistories.value = true;
//
// final data = await _authRepo.getMedicalHistories(
// page: currentPage,
// limit: limit,
// );
//
// medicalHistories.assignAll(data);
//
// if (data.length < limit) {
// hasMoreHistories.value = false;
// }
// } catch (e) {
// medicalHistories.clear();
// hasMoreHistories.value = false;
// _showErrorSnackbar(
// "فشل جلب السجل المرضي",
// e.toString(),
// );
// } finally {
// isHistoryLoading.value = false;
// }
// }
//
// Future<void> fetchNextHistoriesPage() async {
// if (!hasMoreHistories.value ||
// isHistoryLoading.value) {
// return;
// }
//
// try {
// isHistoryLoading.value = true;
//
// currentPage++;
//
// final data = await _authRepo.getMedicalHistories(
// page: currentPage,
// limit: limit,
// );
//
// if (data.isEmpty) {
// hasMoreHistories.value = false;
// } else {
// medicalHistories.addAll(data);
//
// if (data.length < limit) {
// hasMoreHistories.value = false;
// }
// }
// } catch (e) {
// currentPage--;
//
// _showErrorSnackbar(
// "فشل تحميل المزيد من الزيارات",
// e.toString(),
// );
// } finally {
// isHistoryLoading.value = false;
// }
// }
//
// // ==================== Attachments ====================
//
// Future<void> fetchAttachments() async {
// try {
// isAttachmentsLoading.value = true;
//
// final dynamic response =
// await _authRepo.getMedicalAttachments();
//
// List<dynamic> allAttachments = [];
//
// if (response is Map<String, dynamic>) {
// if (response['profileAttachments'] is List) {
// allAttachments.addAll(
// response['profileAttachments'],
// );
// }
//
// if (response['historyAttachments'] is List) {
// allAttachments.addAll(
// response['historyAttachments'],
// );
// }
// } else if (response is List) {
// allAttachments = response;
// }
//
// attachments.assignAll(allAttachments);
//
// print(
// "RAW ATTACHMENTS RESPONSE: $response",
// );
// } catch (e) {
// attachments.clear();
// } finally {
// isAttachmentsLoading.value = false;
// }
// }
//
// // ==================== Upload Attachment ====================
//
// Future<void> uploadAttachment() async {
// try {
// const XTypeGroup typeGroup = XTypeGroup(
// label: 'Medical Documents',
// extensions: [
// 'jpg',
// 'jpeg',
// 'png',
// 'pdf',
// 'doc',
// 'docx',
// ],
// );
//
// final XFile? file = await openFile(
// acceptedTypeGroups: [
// typeGroup,
// ],
// );
//
// // User cancelled file selection
// if (file == null) {
// return;
// }
//
// final String filePath = file.path;
// final String fileName = file.name;
//
// isAttachmentsLoading.value = true;
//
// await _authRepo.uploadMedicalAttachment(
// filePath,
// fileName,
// );
//
// await fetchAttachments();
//
// Get.snackbar(
// "نجاح",
// "تم رفع المرفق بنجاح",
// snackPosition: SnackPosition.BOTTOM,
// backgroundColor:
// Colors.green.withValues(alpha: 0.1),
// colorText: Colors.green,
// );
// } catch (e) {
// _showErrorSnackbar(
// "فشل رفع المرفق",
// e.toString(),
// );
// } finally {
// isAttachmentsLoading.value = false;
// }
// }
//
// // ==================== Delete Attachment ====================
//
// Future<void> deleteAttachment(
// int attachmentId,
// ) async {
// try {
// await _authRepo.deleteMedicalAttachment(
// attachmentId,
// );
//
// attachments.removeWhere(
// (item) =>
// int.tryParse(
// item['id']?.toString() ?? '0',
// ) ==
// attachmentId,
// );
//
// Get.snackbar(
// "نجاح",
// "تم حذف المرفق بنجاح",
// snackPosition: SnackPosition.BOTTOM,
// );
// } catch (e) {
// Get.snackbar(
// "خطأ",
// "فشل حذف المرفق: $e",
// snackPosition: SnackPosition.BOTTOM,
// );
// }
// }
//
// // ==================== Medicines ====================
//
// Future<void> fetchMyMedicines() async {
// try {
// isMedicinesLoading.value = true;
//
// final data = await _authRepo.getMyMedicines();
//
// myMedicines.assignAll(data);
// } catch (e) {
// myMedicines.clear();
// _showErrorSnackbar(
// "فشل جلب الأدوية",
// e.toString(),
// );
// } finally {
// isMedicinesLoading.value = false;
// }
// }
//
// // ==================== Update Profile ====================
//
// Future<void> updateProfileData(
// Map<String, dynamic> updatedData,
// ) async {
// try {
// isProfileLoading.value = true;
//
// await _authRepo.updateMedicalProfileMe(
// updatedData,
// );
//
// await fetchMedicalProfile();
//
// Get.snackbar(
// "نجاح",
// "تم تحديث الملف الطبي بنجاح",
// snackPosition: SnackPosition.BOTTOM,
// backgroundColor:
// Colors.green.withValues(alpha: 0.1),
// colorText: Colors.green,
// );
// } catch (e) {
// _showErrorSnackbar(
// "فشل التحديث",
// e.toString(),
// );
// } finally {
// isProfileLoading.value = false;
// }
// }
//
// // ==================== Error Snackbar ====================
//
// void _showErrorSnackbar(
// String title,
// String message,
// ) {
// Get.snackbar(
// title,
// message,
// snackPosition: SnackPosition.BOTTOM,
// backgroundColor:
// Colors.redAccent.withValues(alpha: 0.1),
// colorText: Colors.red,
// );
// }
//
// // ==================== Dispose ====================
//
// @override
// void onClose() {
// tabController.dispose();
// historyScrollController.dispose();
//
// super.onClose();
// }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:file_selector/file_selector.dart';

import '../../auth/repository/auth_repository.dart';
import '../model/medical_record_model.dart'
    show MedicalProfileLookupOption, MedicalProfileModel;
// استدعي الموديل الجديد هنا إن لزم الأمر
// import '../models/medical_profile_model.dart';

class MedicalRecordController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  final AuthRepository _authRepo = AuthRepository();

  // ==================== Medical Profile ====================

  var isProfileLoading = false.obs;
  var completionRate = 0.0.obs;

  // نموذج الملف الطبي الشامل
  Rxn<MedicalProfileModel> medicalProfile = Rxn<MedicalProfileModel>();
  final isProfileLookupsLoading = false.obs;
  final isProfileSaving = false.obs;
  final lastProfileSaveError = RxnString();

  static const bloodTypeLookupCategory = 'BLOOD_TYPE';
  static const disabilityTypesLookupCategory = 'DISABILITY_TYPES';
  static const allergyLookupCategory = 'ALLERGY';
  static const chronicConditionLookupCategory = 'CHRONIC_CONDITION';
  static const commonSurgeriesLookupCategory = 'COMMON_SURGERIES';
  static const lifestyleHabitsLookupCategory = 'LIFESTYLE_HABITS';

  final RxMap<String, List<MedicalProfileLookupOption>> _medicalProfileLookups =
      <String, List<MedicalProfileLookupOption>>{}.obs;

  List<MedicalProfileLookupOption> lookupOptionsFor(String category) {
    return _medicalProfileLookups[category] ??
        const <MedicalProfileLookupOption>[];
  }

  // ==================== Medical History ====================

  var isHistoryLoading = false.obs;
  var medicalHistories = [].obs;

  var currentPage = 1;
  final int limit = 20;
  var hasMoreHistories = true.obs;

  final ScrollController historyScrollController = ScrollController();

  // ==================== Attachments ====================

  var isAttachmentsLoading = false.obs;
  var attachments = [].obs;

  // ==================== Medicines ====================

  var isMedicinesLoading = false.obs;
  var myMedicines = [].obs;

  // ==================== Lifecycle ====================

  @override
  void onInit() {
    super.onInit();

    tabController = TabController(length: 3, vsync: this);

    historyScrollController.addListener(() {
      if (historyScrollController.position.pixels >=
          historyScrollController.position.maxScrollExtent) {
        fetchNextHistoriesPage();
      }
    });

    fetchMedicalProfile();
    fetchMedicalHistories();
    fetchAttachments();
    fetchMyMedicines();
  }

  // ==================== Medical Profile ====================

  Future<void> fetchMedicalProfile() async {
    try {
      isProfileLoading.value = true;
      final data = await _authRepo.getMedicalProfileDetails();
      if (data is Map<String, dynamic>) {
        medicalProfile.value = MedicalProfileModel.fromJson(data);
        try {
          final completion = await _authRepo
              .getMedicalProfileCompletionStatus();
          final rawPercentage = completion['completionPercentage'];
          final percentage = rawPercentage is num
              ? rawPercentage.toDouble()
              : 0.0;
          completionRate.value = percentage > 1.0
              ? percentage / 100.0
              : percentage;
        } catch (_) {
          completionRate.value = 0.0;
        }
      } else {
        medicalProfile.value = null;
        completionRate.value = 0.0;
      }
    } catch (e) {
      medicalProfile.value = null;
      completionRate.value = 0.0;
      _showErrorSnackbar('Failed to load medical profile', e.toString());
    } finally {
      isProfileLoading.value = false;
    }
  }

  Future<void> loadMedicalProfileLookups() async {
    if (isProfileLookupsLoading.value) return;
    const categories = <String>[
      bloodTypeLookupCategory,
      disabilityTypesLookupCategory,
      allergyLookupCategory,
      chronicConditionLookupCategory,
      commonSurgeriesLookupCategory,
      lifestyleHabitsLookupCategory,
    ];

    try {
      isProfileLookupsLoading.value = true;
      final loaded = await Future.wait(
        categories.map((category) => _authRepo.getLookupsByCategory(category)),
      );
      final options = <String, List<MedicalProfileLookupOption>>{};
      for (var index = 0; index < categories.length; index++) {
        options[categories[index]] = loaded[index]
            .map(MedicalProfileLookupOption.fromJson)
            .where((option) => option.value.isNotEmpty)
            .toList();
      }
      _medicalProfileLookups.assignAll(options);
    } catch (e) {
      _medicalProfileLookups.clear();
      _showErrorSnackbar(
        'Failed to load medical profile options',
        e.toString(),
      );
    } finally {
      isProfileLookupsLoading.value = false;
    }
  }

  Future<bool> saveMedicalProfile(Map<String, dynamic> profileData) async {
    final wasCreating = medicalProfile.value == null;
    lastProfileSaveError.value = null;

    try {
      isProfileSaving.value = true;
      if (wasCreating) {
        await _authRepo.createMedicalProfileMe(profileData);
      } else {
        await _authRepo.updateMedicalProfileMe(profileData);
      }

      await fetchMedicalProfile();
      return true;
    } catch (e) {
      lastProfileSaveError.value = _profileSaveErrorMessage(e);
      return false;
    } finally {
      isProfileSaving.value = false;
    }
  }

  String _profileSaveErrorMessage(Object error) {
    final message = error.toString().replaceFirst('Exception: ', '').trim();
    return message.isEmpty ? 'Unable to save medical profile.' : message;
  }

  // ==================== Medical History ====================

  Future<void> fetchMedicalHistories() async {
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

  Future<void> fetchNextHistoriesPage() async {
    if (!hasMoreHistories.value || isHistoryLoading.value) {
      return;
    }

    try {
      isHistoryLoading.value = true;
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
    } finally {
      isHistoryLoading.value = false;
    }
  }

  // ==================== Attachments ====================

  Future<void> fetchAttachments() async {
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
    } catch (e) {
      attachments.clear();
    } finally {
      isAttachmentsLoading.value = false;
    }
  }

  Future<void> uploadAttachment() async {
    try {
      const XTypeGroup typeGroup = XTypeGroup(
        label: 'Medical Documents',
        extensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
      );

      final XFile? file = await openFile(acceptedTypeGroups: [typeGroup]);
      if (file == null) return;

      isAttachmentsLoading.value = true;
      await _authRepo.uploadMedicalAttachment(file.path, file.name);
      await fetchAttachments();

      Get.snackbar(
        "نجاح",
        "تم رفع المرفق بنجاح",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        colorText: Colors.green,
      );
    } catch (e) {
      _showErrorSnackbar("فشل رفع المرفق", e.toString());
    } finally {
      isAttachmentsLoading.value = false;
    }
  }

  Future<void> deleteAttachment(int attachmentId) async {
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

  // ==================== Medicines ====================

  Future<void> fetchMyMedicines() async {
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

  // ==================== Update Profile ====================

  Future<void> updateProfileData(Map<String, dynamic> updatedData) async {
    await saveMedicalProfile(updatedData);
  }

  // ==================== Error Snackbar ====================

  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
      colorText: Colors.red,
    );
  }

  // ==================== Dispose ====================

  @override
  void onClose() {
    tabController.dispose();
    historyScrollController.dispose();
    super.onClose();
  }
}
