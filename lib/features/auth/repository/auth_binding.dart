import 'package:get/get.dart';
import '../repository/auth_repository.dart';
import '../repository/AuthController.dart';
import '../../LoginScreen/controller/login_controller.dart';
import '../../RegisterScreen/controller/register_controller.dart';
import '../../notifications/controller/notification_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthRepository>()) {
      Get.put(AuthRepository(), permanent: true);
    }

    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController(), permanent: true);
    }

    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => RegisterController());

    Get.lazyPut(() => NotificationController());
  }
}
