import 'package:get/get.dart';
import '../model/medical_record_model.dart';

class MedicalRecordsController extends GetxController {
  RxInt selectedIndex = 0.obs;

  RxList<MedicalRecordModel> records = <MedicalRecordModel>[].obs;

  void uploadRecord() {}

  void openRecord(MedicalRecordModel record) {}

  void changeBottomNav(int index) {
    selectedIndex.value = index;
  }
}
