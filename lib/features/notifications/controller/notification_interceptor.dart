import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import '/features/settings/controller/controller_settings.dart';

class NotificationInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (getx.Get.isRegistered<SettingsController>()) {
      final settingsController = getx.Get.find<SettingsController>();

      if (options.path.contains('/notifications') &&
          !settingsController.notifications.value) {
        print(
          "🚫 [Notification System]: تم حظر طلب الشبكة لأن الإشعارات معطلة من الإعدادات.",
        );

        return handler.resolve(
          Response(requestOptions: options, data: [], statusCode: 200),
        );
      }
    }

    super.onRequest(options, handler);
  }
}
