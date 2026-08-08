// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../auth/data/models/notifications_model.dart';
// import '../../auth/repository/auth_repository.dart';
//
// class NotificationsController extends GetxController {
//   final AuthRepository _authRepository = AuthRepository();
//
//   var notifications = <NotificationsModel>[].obs;
//   var isLoading = false.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchNotifications();
//   }
//
//   Future<void> fetchNotifications() async {
//     try {
//       isLoading.value = true;
//       final result = await _authRepository.getMyNotifications(lang: 'en');
//
//       notifications.value = result
//           .where(
//             (n) =>
//                 n.type.toUpperCase() == 'APPOINTMENT' ||
//                 n.messageKey.toString().contains('appointment'),
//           )
//           .toList();
//     } catch (e) {
//       debugPrint("❌ خطأ في جلب الإشعارات: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> markAsRead(int id) async {
//     try {
//       await _authRepository.markNotificationAsRead(id);
//       final index = notifications.indexWhere((n) => n.id == id);
//       if (index != -1) {
//         final updated = notifications[index];
//         notifications[index] = NotificationsModel(
//           id: updated.id,
//           userId: updated.userId,
//           title: updated.title,
//           body: updated.body,
//           messageKey: updated.messageKey,
//           arguments: updated.arguments,
//           type: updated.type,
//           priority: updated.priority,
//           targetType: updated.targetType,
//           targetId: updated.targetId,
//           actionUrl: updated.actionUrl,
//           status: updated.status,
//           readAt: DateTime.now().toIso8601String(),
//           createdAt: updated.createdAt,
//         );
//         notifications.refresh();
//       }
//     } catch (e) {
//       debugPrint("❌ خطأ في تحديد الإشعار كمقروء: $e");
//     }
//   }
//
//   Future<void> markAllAsRead() async {
//     try {
//       await _authRepository.markAllNotificationsAsRead();
//       fetchNotifications();
//     } catch (e) {
//       debugPrint("❌ خطأ في تحديد كل الإشعارات كمقروءة: $e");
//     }
//   }
//
//   void onNotificationTap(NotificationsModel notification) {
//     if (!notification.isRead) {
//       markAsRead(notification.id);
//     }
//
//     if (notification.targetType == 'APPOINTMENT' &&
//         notification.targetId != null) {
//       Get.toNamed('/appointment-details', arguments: notification.targetId);
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../auth/data/models/notifications_model.dart';
import '../../auth/repository/auth_repository.dart';

// استيراد ملفات الرسائل والتنبيهات المركزية
import '../../../core/constance/app_messages.dart';
import '../../../core/constance/app_alerts.dart';

class NotificationsController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  var notifications = <NotificationsModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final result = await _authRepository.getMyNotifications(lang: 'en');

      notifications.value = result
          .where(
            (n) =>
        n.type.toUpperCase() == 'APPOINTMENT' ||
            n.messageKey.toString().contains('appointment'),
      )
          .toList();
    } catch (e) {
      debugPrint("❌ خطأ في جلب الإشعارات: $e");
      AppAlerts.showError(
        title: AppMessages.notificationsErrorTitle,
        message: "${AppMessages.fetchNotificationsError}$e",
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      await _authRepository.markNotificationAsRead(id);
      final index = notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        final updated = notifications[index];
        notifications[index] = NotificationsModel(
          id: updated.id,
          userId: updated.userId,
          title: updated.title,
          body: updated.body,
          messageKey: updated.messageKey,
          arguments: updated.arguments,
          type: updated.type,
          priority: updated.priority,
          targetType: updated.targetType,
          targetId: updated.targetId,
          actionUrl: updated.actionUrl,
          status: updated.status,
          readAt: DateTime.now().toIso8601String(),
          createdAt: updated.createdAt,
        );
        notifications.refresh();
      }
    } catch (e) {
      debugPrint("❌ خطأ في تحديد الإشعار كمقروء: $e");
      AppAlerts.showError(
        title: AppMessages.notificationsErrorTitle,
        message: "${AppMessages.markReadError}$e",
      );
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _authRepository.markAllNotificationsAsRead();
      fetchNotifications();
    } catch (e) {
      debugPrint("❌ خطأ في تحديد كل الإشعارات كمقروءة: $e");
      AppAlerts.showError(
        title: AppMessages.notificationsErrorTitle,
        message: "${AppMessages.markAllReadError}$e",
      );
    }
  }

  void onNotificationTap(NotificationsModel notification) {
    if (!notification.isRead) {
      markAsRead(notification.id);
    }

    if (notification.targetType == 'APPOINTMENT' &&
        notification.targetId != null) {
      Get.toNamed('/appointment-details', arguments: notification.targetId);
    }
  }
}