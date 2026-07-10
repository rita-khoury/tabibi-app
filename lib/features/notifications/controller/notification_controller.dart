import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../auth/repository/auth_repository.dart';
import '../model/notification_model.dart';

class NotificationController extends GetxController {
  final Dio _dio = Get.find<AuthRepository>().dio;

  var isLoading = false.obs;
  var notificationsList = <NotificationModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    fetchNotifications("en");
  }

  Future<void> fetchNotifications(String languageCode) async {
    try {
      isLoading.value = true;

      final response = await _dio.get(
        "/notifications/me",
        options: Options(headers: {"accept-language": languageCode}),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        notificationsList.value = data
            .map((json) => NotificationModel.fromJson(json))
            .toList();
      }
    } catch (e) {
      if (e is DioException) {
        print(" Error fetching notifications: ${e.message}");
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(int notificationId) async {
    try {
      final response = await _dio.patch("/notifications/$notificationId/read");

      if (response.statusCode == 200) {
        int index = notificationsList.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          notificationsList[index] = notificationsList[index].copyWith(
            readAt: DateTime.now(),
          );
          notificationsList.refresh();
        }
      }
    } catch (e) {
      print("❌ Error marking as read: $e");
    }
  }

  Future<void> markAllNotificationsAsRead() async {
    try {
      final response = await _dio.patch("/notifications/read-all");

      if (response.statusCode == 200) {
        for (var i = 0; i < notificationsList.length; i++) {
          notificationsList[i] = notificationsList[i].copyWith(
            readAt: DateTime.now(),
          );
        }
        notificationsList.refresh();
      }
    } catch (e) {
      print("❌ Error marking all as read: $e");
    }
  }
}
