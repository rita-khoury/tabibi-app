// import 'package:get/get.dart';
//
// import '../../auth/data/models/LookupModel.dart';
// import '../../auth/repository/auth_repository.dart';
//
// class SpecialitiesController extends GetxController {
//   final AuthRepository _repo = Get.find();
//   var specialities = <LookupModel>[].obs;
//   var isLoading = true.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchSpecialities();
//   }
//
//   Future<void> fetchSpecialities() async {
//     try {
//       isLoading.value = true;
//
//       final data = await _repo.getLookupsByCategory('MEDICAL_SPECIALTY');
//       specialities.value = data.map((e) => LookupModel.fromJson(e)).toList();
//     } catch (e) {
//       Get.snackbar("خطأ", "تعذر جلب التخصصات: ${e.toString()}");
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }


import 'package:get/get.dart';

import '../../auth/data/models/LookupModel.dart';
import '../../auth/repository/auth_repository.dart';

// استيراد ملفات الرسائل والتنبيهات المركزية
import '../../../core/constance/app_messages.dart';
import '../../../core/constance/app_alerts.dart';

class SpecialitiesController extends GetxController {
  final AuthRepository _repo = Get.find();
  var specialities = <LookupModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSpecialities();
  }

  Future<void> fetchSpecialities() async {
    try {
      isLoading.value = true;

      final data = await _repo.getLookupsByCategory('MEDICAL_SPECIALTY');
      specialities.value = data.map((e) => LookupModel.fromJson(e)).toList();
    } catch (e) {
      AppAlerts.showError(
        title: AppMessages.specialitiesErrorTitle,
        message: "${AppMessages.fetchSpecialitiesError}${e.toString()}",
      );
    } finally {
      isLoading.value = false;
    }
  }
}