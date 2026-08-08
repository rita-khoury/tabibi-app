import 'package:get/get.dart';

import '../controller/doctor_ratings_controller.dart';


class DoctorRatingsBinding extends Bindings {
  @override
  void dependencies() {

    final int doctorId = Get.arguments ?? 0;
    Get.lazyPut<DoctorRatingsController>(() => DoctorRatingsController(doctorId: doctorId));
  }
}