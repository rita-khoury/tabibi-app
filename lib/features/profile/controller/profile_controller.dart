/*import 'package:get/get.dart';

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
}*/
import 'package:get/get.dart';

class ProfileController extends GetxController {

  RxString userName = "Guest".obs;
  RxString email = "Not logged in".obs;

  RxString imageUrl = "".obs;

  RxBool isLoggedIn = false.obs;

  RxInt selectedIndex = 0.obs;

  void changeBottomNav(int index) {
    selectedIndex.value = index;
  }

  // 👇 لما يعمل login
  void loginUser({
    required String name,
    required String email,
    required String image,
  }) {
    userName.value = name;
    this.email.value = email;
    imageUrl.value = image;
    isLoggedIn.value = true;
  }

  // 👇 logout
  void logout() {
    userName.value = "Guest";
    email.value = "Not logged in";
    imageUrl.value = "";
    isLoggedIn.value = false;
  }

  void editProfile() {
    userName.value = "Dr. Ahmed";
  }
}