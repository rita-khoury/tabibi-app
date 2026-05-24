import 'package:get/get.dart';
import '../controller/favorites_doctors_controller.dart';

class FavoritesDoctorsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FavoritesDoctorsController());
  }
}