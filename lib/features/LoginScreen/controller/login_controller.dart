import 'package:get/get.dart';

class LoginController extends GetxController {
  final email = ''.obs;
  final password = ''.obs;

  final isPasswordObscured = true.obs;

  void togglePassword() {
    isPasswordObscured.value = !isPasswordObscured.value;
  }

  void setEmail(String value) {
    email.value = value;
  }

  void setPassword(String value) {
    password.value = value;
  }

  void login() {

    print("Email: ${email.value}");
    print("Password: ${password.value}");
  }
}