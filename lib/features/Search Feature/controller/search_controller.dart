import 'package:get/get.dart';
import '../../../core/services/doctor_service.dart';

class DoctorSearchController extends GetxController {
  final DoctorService _service = DoctorService();

  var filteredDoctors = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadAllDoctors();
  }

  Future<void> loadAllDoctors() async {
    try {
      isLoading.value = true;

      final data = await _service.getAll();

      filteredDoctors.assignAll(List<Map<String, dynamic>>.from(data));
    } catch (e) {
      Get.snackbar("خطأ", "فشل تحميل البيانات");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> search(String query) async {
    try {
      isLoading.value = true;

      final results = await _service.search(query);
      filteredDoctors.assignAll(List<Map<String, dynamic>>.from(results));
    } catch (e) {
      Get.snackbar("خطأ", "فشل البحث");
    } finally {
      isLoading.value = false;
    }
  }
}
