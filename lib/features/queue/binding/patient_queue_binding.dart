import 'package:tabibi/features/auth/repository/auth_repository.dart';
import 'package:get/get.dart';
import 'package:tabibi/features/queue/controller/patient_queue_controller.dart';

class PatientQueueBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PatientQueueController>(() => PatientQueueController(Get.find<AuthRepository>()));
  }
}
