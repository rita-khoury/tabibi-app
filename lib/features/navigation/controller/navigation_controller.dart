import 'package:get/get.dart';

import '../../auth/repository/AuthController.dart';

class NavigationController extends GetxController {
  final selectedIndex = 0.obs;
  late final AuthController _authController;
  Worker? _authStateWorker;

  @override
  void onInit() {
    super.onInit();
    _authController = Get.find<AuthController>();
    _authStateWorker = ever(
      _authController.currentUser,
      (_) => _resetToHomeWhenUnauthenticated(),
    );
    _resetToHomeWhenUnauthenticated();
  }

  @override
  void onClose() {
    _authStateWorker?.dispose();
    super.onClose();
  }

  bool get isAuthenticated => _authController.isLoggedIn;

  void changeTab(int index) {
    if (!isAuthenticated && index != 0) {
      selectedIndex.value = 0;
      return;
    }
    selectedIndex.value = index;
  }

  void _resetToHomeWhenUnauthenticated() {
    if (!isAuthenticated && selectedIndex.value != 0) {
      selectedIndex.value = 0;
    }
  }
}
