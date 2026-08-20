import 'package:get/get.dart';
import 'package:tabibi/features/auth/repository/auth_repository.dart';
import 'package:tabibi/features/queue/controller/patient_queue_state_controller.dart';
import 'package:tabibi/features/queue/repository/patient_queue_repository.dart';

class PatientQueueBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<PatientQueueRepository>()) {
      Get.lazyPut(() => PatientQueueRepository(Get.find<AuthRepository>()));
    }
    if (!Get.isRegistered<PatientQueueStateController>()) {
      Get.lazyPut(
        () => PatientQueueStateController(Get.find<PatientQueueRepository>()),
      );
    }
  }
}
