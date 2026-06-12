import 'package:get/get.dart';

class RegisterController extends GetxController {
  final email = ''.obs;
  final password = ''.obs;
  final name = ''.obs;
  final countryCode = ''.obs;
  final phone = ''.obs;
  final age = ''.obs;

  void setEmail(String v) => email.value = v;
  void setPassword(String v) => password.value = v;
  void setName(String v) => name.value = v;
  void setCountryCode(String v) => countryCode.value = v;
  void setPhone(String v) => phone.value = v;
  void setAge(String v) => age.value = v;

  void register() {
    print("EMAIL: ${email.value}");
    print("PASSWORD: ${password.value}");
    print("NAME: ${name.value}");
    print("COUNTRY: ${countryCode.value}");
    print("PHONE: ${phone.value}");
    print("AGE: ${age.value}");
  }
}