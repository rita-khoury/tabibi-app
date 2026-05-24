import 'package:get/get.dart';

class ProfileController extends GetxController {

  RxString userName = "Ahmed Khaled".obs;

  RxString email = "ahmed.khaled@email.com".obs;

  RxInt selectedIndex = 4.obs;

  void changeBottomNav(int index) {
    selectedIndex.value = index;
  }

  void editProfile() {
    userName.value = "Dr. Ahmed";
  }
}