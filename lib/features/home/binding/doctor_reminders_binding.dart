import 'package:get/get.dart';

import '../controller/doctor_reminders_controller.dart';

class DoctorRemindersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorRemindersController>(() => DoctorRemindersController());
  }
}
