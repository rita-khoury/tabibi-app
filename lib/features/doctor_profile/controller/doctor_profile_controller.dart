import 'package:get/get.dart';

class DoctorProfileController extends GetxController {
  late Map<String, dynamic> doctor;

  void initDoctor(Map<String, dynamic> data) {
    doctor = data;
  }
}