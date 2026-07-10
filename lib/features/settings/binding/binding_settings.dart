import 'package:get/get.dart';
import 'package:tabibi/features/settings/controller/controller_settings.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}
