// import 'package:get/get.dart';
// import '../../auth/repository/auth_repository.dart';
//
// class DoctorRemindersController extends GetxController {
//   final AuthRepository _authRepository = AuthRepository();
//
//   var isLoading = true.obs;
//   var remindersList = [].obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchReminders();
//   }
//
//   void fetchReminders() async {
//     try {
//       isLoading.value = true;
//
//       final result = await _authRepository.getMyActiveReferrals();
//
//       final processedList = (result as List).map((referral) {
//         if (referral is Map<String, dynamic>) {
//           String destinationName = 'Specialist Doctor';
//
//           final toDoc = referral['toDoctor'];
//           if (toDoc != null && toDoc['user'] != null) {
//             final user = toDoc['user'];
//             final fName = user['firstName'] ?? user['first_name'] ?? '';
//             final lName = user['lastName'] ?? user['last_name'] ?? '';
//             if (fName.isNotEmpty || lName.isNotEmpty) {
//               destinationName = 'Dr. $fName $lName';
//             }
//           } else if (referral['toClinic'] != null &&
//               referral['toClinic']['name'] != null) {
//             destinationName = 'Clinic: ${referral['toClinic']['name']}';
//           }
//
//           referral['parsedDoctorName'] = destinationName;
//         }
//         return referral;
//       }).toList();
//
//       remindersList.assignAll(processedList);
//     } catch (e) {
//       Get.snackbar("Error", "Failed to fetch referrals: ${e.toString()}");
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }


import 'package:get/get.dart';
import '../../auth/repository/auth_repository.dart';


import '../../../core/constance/app_messages.dart';
import '../../../core/constance/app_alerts.dart';

class DoctorRemindersController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  var isLoading = true.obs;
  var remindersList = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchReminders();
  }

  void fetchReminders() async {
    try {
      isLoading.value = true;

      final result = await _authRepository.getMyActiveReferrals();

      final processedList = (result as List).map((referral) {
        if (referral is Map<String, dynamic>) {
          String destinationName = 'Specialist Doctor';

          final toDoc = referral['toDoctor'];
          if (toDoc != null && toDoc['user'] != null) {
            final user = toDoc['user'];
            final fName = user['firstName'] ?? user['first_name'] ?? '';
            final lName = user['lastName'] ?? user['last_name'] ?? '';
            if (fName.isNotEmpty || lName.isNotEmpty) {
              destinationName = 'Dr. $fName $lName';
            }
          } else if (referral['toClinic'] != null &&
              referral['toClinic']['name'] != null) {
            destinationName = 'Clinic: ${referral['toClinic']['name']}';
          }

          referral['parsedDoctorName'] = destinationName;
        }
        return referral;
      }).toList();

      remindersList.assignAll(processedList);
    } catch (e) {
      AppAlerts.showError(
        title: AppMessages.remindersErrorTitle,
        message: "${AppMessages.fetchReferralsError}${e.toString()}",
      );
    } finally {
      isLoading.value = false;
    }
  }
}