import 'package:get/get.dart';
import 'package:tabibi/features/medical_records/controller/medical_records_controller.dart';

class MedicalRecordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MedicalRecordController>(() => MedicalRecordController());
  }
}
