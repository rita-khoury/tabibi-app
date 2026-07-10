import 'package:get/get.dart';
import '../controller/medical_records_controller.dart';

class MedicalRecordsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MedicalRecordsController>(() => MedicalRecordsController());
  }
}
