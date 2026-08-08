// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:get_storage/get_storage.dart';
// import '../../auth/repository/auth_repository.dart';
// import '../model/appointment_model.dart';
// import '../model/waitlist_model.dart';
//
// class AppointmentsController extends GetxController {
//   final AuthRepository _repo = Get.find<AuthRepository>();
//   final _storage = GetStorage();
//
//   List<AppointmentModel> upcomingAppointments = [];
//   List<AppointmentModel> completedAppointments = [];
//   List<AppointmentModel> canceledAppointments = [];
//   List<AppointmentModel> noShowAppointments = [];
//   List<WaitlistModel> waitlistAppointments = [];
//
//   bool isLoading = true;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchAppointments();
//     fetchWaitlist();
//   }
//
//   Future<void> fetchAppointments() async {
//     try {
//       isLoading = true;
//       update();
//
//       List<AppointmentModel> result = await _repo.getMyAppointments();
//       List<dynamic> localCanceledIds =
//           _storage.read<List<dynamic>>('canceledIds') ?? [];
//
//       upcomingAppointments = result
//           .where(
//             (a) =>
//                 (a.status == 'pending' || a.status == 'confirmed') &&
//                 !localCanceledIds.contains(a.id),
//           )
//           .toList();
//       completedAppointments = result
//           .where((a) => a.status == 'completed')
//           .toList();
//
//       canceledAppointments = result
//           .where(
//             (a) => a.status == 'cancelled' || localCanceledIds.contains(a.id),
//           )
//           .toList();
//
//       noShowAppointments = result.where((a) => a.status == 'no_show').toList();
//     } catch (e) {
//       debugPrint("❌ خطأ في جلب المواعيد: $e");
//     } finally {
//       isLoading = false;
//       update();
//     }
//   }
//
//   Future<void> fetchWaitlist() async {
//     try {
//       var result = await _repo.getMyWaitlists();
//
//       debugPrint("🔥 RAW WAITLIST DATA: $result");
//
//       waitlistAppointments = (result as List)
//           .map((item) => WaitlistModel.fromJson(item))
//           .toList();
//       update();
//     } catch (e) {
//       debugPrint("❌ خطأ في جلب الويت ليست: $e");
//     }
//   }
//
//   Future<void> leaveWaitlist({
//     required int doctorId,
//     required int clinicId,
//     required String requestedDate,
//   }) async {
//     try {
//       await _repo.leaveWaitlist(
//         doctorId: doctorId,
//         clinicId: clinicId,
//         requestedDate: requestedDate,
//       );
//
//       Get.snackbar(
//         "نجاح",
//         "تمت مغادرة قائمة الانتظار بنجاح",
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );
//
//       await fetchWaitlist();
//     } catch (e) {
//       Get.snackbar(
//         "خطأ",
//         "فشل مغادرة قائمة الانتظار",
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//     }
//   }
//
//   Future<void> cancelAppointmentById(int id) async {
//     var appointmentToCancel = upcomingAppointments.firstWhereOrNull(
//       (a) => a.id == id,
//     );
//     if (appointmentToCancel == null) return;
//
//     List<dynamic> localCanceledIds =
//         _storage.read<List<dynamic>>('canceledIds') ?? [];
//     if (!localCanceledIds.contains(id)) {
//       localCanceledIds.add(id);
//       await _storage.write('canceledIds', localCanceledIds);
//     }
//
//     upcomingAppointments.remove(appointmentToCancel);
//     canceledAppointments.add(appointmentToCancel.copyWith(status: 'cancelled'));
//
//     update();
//
//     try {
//       await _repo.cancelAppointment(id, "User cancelled");
//       Get.snackbar(
//         "نجاح",
//         "تم إلغاء الموعد",
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );
//     } catch (e) {
//       await fetchAppointments();
//       Get.snackbar(
//         "خطأ",
//         "فشل الاتصال",
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//     }
//   }
//
//   Future<void> completeAppointmentById(int id) async {
//     try {
//       await _repo.completeAppointment(id);
//       Get.snackbar(
//         "نجاح",
//         "تم إكمال الموعد",
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );
//       await fetchAppointments();
//     } catch (e) {
//       Get.snackbar(
//         "خطأ",
//         "فشل الإتمام",
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//     }
//   }
// }


//
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:get_storage/get_storage.dart';
// import '../../auth/repository/auth_repository.dart';
// import '../model/appointment_model.dart';
// import '../model/waitlist_model.dart';
//
// class AppointmentsController extends GetxController {
//   final AuthRepository _repo = Get.find<AuthRepository>();
//   final _storage = GetStorage();
//
//   List<AppointmentModel> upcomingAppointments = [];
//   List<AppointmentModel> completedAppointments = [];
//   List<AppointmentModel> canceledAppointments = [];
//   List<AppointmentModel> noShowAppointments = [];
//   List<WaitlistModel> waitlistAppointments = [];
//
//   bool isLoading = true;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchAppointments();
//     fetchWaitlist();
//   }
//
//   Future<void> fetchAppointments() async {
//     try {
//       isLoading = true;
//       update();
//
//       List<AppointmentModel> result = await _repo.getMyAppointments();
//       List<dynamic> localCanceledIds =
//           _storage.read<List<dynamic>>('canceledIds') ?? [];
//
//       upcomingAppointments = result
//           .where(
//             (a) =>
//         (a.status == 'pending' || a.status == 'confirmed') &&
//             !localCanceledIds.contains(a.id),
//       )
//           .toList();
//       completedAppointments = result
//           .where((a) => a.status == 'completed')
//           .toList();
//
//       canceledAppointments = result
//           .where(
//             (a) => a.status == 'cancelled' || localCanceledIds.contains(a.id),
//       )
//           .toList();
//
//       noShowAppointments = result.where((a) => a.status == 'no_show').toList();
//     } catch (e) {
//       debugPrint("❌ خطأ في جلب المواعيد: $e");
//     } finally {
//       isLoading = false;
//       update();
//     }
//   }
//
//   Future<void> fetchWaitlist() async {
//     try {
//       var result = await _repo.getMyWaitlists();
//
//       debugPrint("🔥 RAW WAITLIST DATA: $result");
//
//       waitlistAppointments = (result as List)
//           .map((item) => WaitlistModel.fromJson(item))
//           .toList();
//       update();
//     } catch (e) {
//       debugPrint("❌ خطأ في جلب الويت ليست: $e");
//     }
//   }
//
//   // /// الانضمام إلى قائمة الانتظار
//   // Future<void> joinWaitlist({
//   //   required int doctorId,
//   //   required int clinicId,
//   //   required String requestedDate,
//   // }) async {
//   //   try {
//   //     bool success = await _repo.joinWaitlist(
//   //       doctorId: doctorId,
//   //       clinicId: clinicId,
//   //       requestedDate: requestedDate,
//   //     );
//   //
//   //     if (success) {
//   //       Get.snackbar(
//   //         "نجاح",
//   //         "تمت إضافتك إلى قائمة الانتظار بنجاح",
//   //         backgroundColor: Colors.green,
//   //         colorText: Colors.white,
//   //       );
//   //       await fetchWaitlist(); // تحديث القائمة بعد الانضمام
//   //     }
//   //   } catch (e) {
//   //     Get.snackbar(
//   //       "خطأ",
//   //       e.toString().replaceAll("Exception: ", ""),
//   //       backgroundColor: Colors.redAccent,
//   //       colorText: Colors.white,
//   //     );
//   //   }
//   // }
//
//   /// الانضمام إلى قائمة الانتظار
//   Future<void> joinWaitlist({
//     required int doctorId,
//     required int clinicId,
//     required String requestedDate,
//   }) async {
//     try {
//       bool success = await _repo.joinWaitlist(
//         doctorId: doctorId,
//         clinicId: clinicId,
//         requestedDate: requestedDate,
//       );
//
//       if (success) {
//         Get.snackbar(
//           "نجاح",
//           "تمت إضافتك إلى قائمة الانتظار بنجاح",
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );
//         await fetchWaitlist(); // تحديث القائمة بعد الانضمام
//       }
//     } catch (e) {
//       // إظهار نص الخطأ الكامل والصريح القادم من الخادم أو الاستثناء
//       String errorMessage = e.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
//
//       Get.snackbar(
//         "خطأ في الانضمام",
//         errorMessage,
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//         duration: const Duration(seconds: 4), // لزيادة مدة ظهور الرسالة لتتم قراءتها بالكامل
//       );
//     }
//   }
//   Future<void> leaveWaitlist({
//     required int doctorId,
//     required int clinicId,
//     required String requestedDate,
//   }) async {
//     try {
//       await _repo.leaveWaitlist(
//         doctorId: doctorId,
//         clinicId: clinicId,
//         requestedDate: requestedDate,
//       );
//
//       Get.snackbar(
//         "نجاح",
//         "تمت مغادرة قائمة الانتظار بنجاح",
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );
//
//       await fetchWaitlist();
//     } catch (e) {
//       Get.snackbar(
//         "خطأ",
//         "فشل مغادرة قائمة الانتظار",
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//     }
//   }
//
//   Future<void> cancelAppointmentById(int id) async {
//     var appointmentToCancel = upcomingAppointments.firstWhereOrNull(
//           (a) => a.id == id,
//     );
//     if (appointmentToCancel == null) return;
//
//     List<dynamic> localCanceledIds =
//         _storage.read<List<dynamic>>('canceledIds') ?? [];
//     if (!localCanceledIds.contains(id)) {
//       localCanceledIds.add(id);
//       await _storage.write('canceledIds', localCanceledIds);
//     }
//
//     upcomingAppointments.remove(appointmentToCancel);
//     canceledAppointments.add(appointmentToCancel.copyWith(status: 'cancelled'));
//
//     update();
//
//     try {
//       await _repo.cancelAppointment(id, "User cancelled");
//       Get.snackbar(
//         "نجاح",
//         "تم إلغاء الموعد",
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );
//     } catch (e) {
//       await fetchAppointments();
//       Get.snackbar(
//         "خطأ",
//         "فشل الاتصال",
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//     }
//   }
//
//   Future<void> completeAppointmentById(int id) async {
//     try {
//       await _repo.completeAppointment(id);
//       Get.snackbar(
//         "نجاح",
//         "تم إكمال الموعد",
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );
//       await fetchAppointments();
//     } catch (e) {
//       Get.snackbar(
//         "خطأ",
//         "فشل الإتمام",
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//     }
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../auth/repository/auth_repository.dart';
import '../model/appointment_model.dart';
import '../model/waitlist_model.dart';

// استيراد ملف الرسائل المركزي وملف التنبيهات الموحدة
import '../../../core/constance/app_messages.dart';
import '../../../core/constance/app_alerts.dart';

class AppointmentsController extends GetxController {
  final AuthRepository _repo = Get.find<AuthRepository>();
  final _storage = GetStorage();

  List<AppointmentModel> upcomingAppointments = [];
  List<AppointmentModel> completedAppointments = [];
  List<AppointmentModel> canceledAppointments = [];
  List<AppointmentModel> noShowAppointments = [];
  List<WaitlistModel> waitlistAppointments = [];

  bool isLoading = true;

  @override
  void onInit() {
    super.onInit();
    fetchAppointments();
    fetchWaitlist();
  }

  Future<void> fetchAppointments() async {
    try {
      isLoading = true;
      update();

      List<AppointmentModel> result = await _repo.getMyAppointments();
      List<dynamic> localCanceledIds =
          _storage.read<List<dynamic>>('canceledIds') ?? [];

      upcomingAppointments = result
          .where(
            (a) =>
        (a.status == 'pending' || a.status == 'confirmed') &&
            !localCanceledIds.contains(a.id),
      )
          .toList();
      completedAppointments = result
          .where((a) => a.status == 'completed')
          .toList();

      canceledAppointments = result
          .where(
            (a) => a.status == 'cancelled' || localCanceledIds.contains(a.id),
      )
          .toList();

      noShowAppointments = result.where((a) => a.status == 'no_show').toList();
    } catch (e) {
      debugPrint("❌ خطأ في جلب المواعيد: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> fetchWaitlist() async {
    try {
      var result = await _repo.getMyWaitlists();

      debugPrint("🔥 RAW WAITLIST DATA: $result");

      waitlistAppointments = (result as List)
          .map((item) => WaitlistModel.fromJson(item))
          .toList();
      update();
    } catch (e) {
      debugPrint("❌ خطأ في جلب الويت ليست: $e");
    }
  }

  /// الانضمام إلى قائمة الانتظار
  Future<void> joinWaitlist({
    required int doctorId,
    required int clinicId,
    required String requestedDate,
  }) async {
    try {
      bool success = await _repo.joinWaitlist(
        doctorId: doctorId,
        clinicId: clinicId,
        requestedDate: requestedDate,
      );

      if (success) {
        AppAlerts.showSuccess(
          title: AppMessages.waitlistSuccessTitle,
          message: AppMessages.waitlistSuccessBody,
        );
        await fetchWaitlist(); // تحديث القائمة بعد الانضمام
      }
    } catch (e) {
      // إظهار نص الخطأ الكامل والصريح القادم من الخادم أو الاستثناء
      String errorMessage = e.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');

      AppAlerts.showError(
        title: AppMessages.waitlistErrorTitle,
        message: errorMessage,
      );
    }
  }

  Future<void> leaveWaitlist({
    required int doctorId,
    required int clinicId,
    required String requestedDate,
  }) async {
    try {
      await _repo.leaveWaitlist(
        doctorId: doctorId,
        clinicId: clinicId,
        requestedDate: requestedDate,
      );

      AppAlerts.showSuccess(
        title: AppMessages.waitlistLeaveTitle,
        message: AppMessages.waitlistLeaveBody,
      );

      await fetchWaitlist();
    } catch (e) {
      AppAlerts.showError(
        title: AppMessages.waitlistLeaveErrorTitle,
        message: AppMessages.waitlistLeaveErrorBody,
      );
    }
  }

  Future<void> cancelAppointmentById(int id) async {
    var appointmentToCancel = upcomingAppointments.firstWhereOrNull(
          (a) => a.id == id,
    );
    if (appointmentToCancel == null) return;

    List<dynamic> localCanceledIds =
        _storage.read<List<dynamic>>('canceledIds') ?? [];
    if (!localCanceledIds.contains(id)) {
      localCanceledIds.add(id);
      await _storage.write('canceledIds', localCanceledIds);
    }

    upcomingAppointments.remove(appointmentToCancel);
    canceledAppointments.add(appointmentToCancel.copyWith(status: 'cancelled'));

    update();

    try {
      await _repo.cancelAppointment(id, "User cancelled");
      AppAlerts.showSuccess(
        title: AppMessages.successTitle,
        message: AppMessages.appointmentCancelSuccess,
      );
    } catch (e) {
      await fetchAppointments();
      AppAlerts.showError(
        title: AppMessages.errorTitle,
        message: AppMessages.appointmentCancelError,
      );
    }
  }

  Future<void> completeAppointmentById(int id) async {
    try {
      await _repo.completeAppointment(id);
      AppAlerts.showSuccess(
        title: AppMessages.successTitle,
        message: AppMessages.appointmentCompleteSuccess,
      );
      await fetchAppointments();
    } catch (e) {
      AppAlerts.showError(
        title: AppMessages.errorTitle,
        message: AppMessages.appointmentCompleteError,
      );
    }
  }
}