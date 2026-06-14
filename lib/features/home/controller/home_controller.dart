import 'package:get/get.dart';
import 'package:tabibi/core/services/doctor_service.dart';

class HomeController extends GetxController {
  final DoctorService _service = DoctorService();

  List<Map<String, dynamic>> topDoctors = [];
  var filteredDoctors = <Map<String, dynamic>>[].obs;
  var isSearching = false.obs;

  @override
  void onInit() {
    super.onInit();
    List<Map<String, dynamic>> all = _service.getAll();
    // تصفية النخبة (تقييم 4.8 فأعلى)
    topDoctors = all.where((doc) => (doc['rating'] as num).toDouble() >= 4.8).toList();
    filteredDoctors.assignAll(topDoctors);
  }

  void searchDoctor(String query) {
    // تحديث حالة البحث
    isSearching.value = query.isNotEmpty;

    // الفلترة
    var source = query.isNotEmpty ? _service.getAll() : topDoctors;
    filteredDoctors.assignAll(source.where((doc) =>
    doc['name'].toString().toLowerCase().contains(query.toLowerCase()) ||
        doc['speciality'].toString().toLowerCase().contains(query.toLowerCase())
    ).toList());
  }
}