import 'package:get/get.dart';
import 'auth_repository.dart';
import 'AuthController.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthRepository(), permanent: true);
    Get.put(AuthController(), permanent: true);

    // ❌ احذف الأسطر التالية تماماً إذا كانت موجودة هنا:
    // Get.lazyPut(() => LoginController());
    // Get.lazyPut(() => RegisterController());
    // Get.lazyPut(() => NotificationController());
  }
}