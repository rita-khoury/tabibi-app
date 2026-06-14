import 'package:get/get.dart';
import '../../../core/services/doctor_service.dart';

class DoctorSearchController extends GetxController {
  final DoctorService _service = DoctorService();

  // القائمة التي تراقبها الواجهات
  var filteredDoctors = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // تحميل البيانات الأولية
    filteredDoctors.assignAll(_service.getAll());
  }

  void search(String query) {
    filteredDoctors.assignAll(_service.search(query));
  }
}