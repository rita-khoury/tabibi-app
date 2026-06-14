// المسار: lib/features/search/binding/search_binding.dart
import 'package:get/get.dart';
import '../controller/search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorSearchController>(() => DoctorSearchController());
  }
}