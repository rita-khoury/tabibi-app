import 'package:get/get.dart';
import 'package:tabibi/features/appointments/model/appointment_model.dart';
import 'package:tabibi/features/auth/repository/AuthController.dart';
import 'package:tabibi/features/auth/repository/auth_repository.dart';
import 'package:tabibi/features/profile_updates/model/medical_profile_update_model.dart';

class ProfileUpdatesController extends GetxController {
  final AuthRepository _repository = AuthRepository();

  final isLoading = false.obs;
  final errorMessage = RxnString();
  final updates = <MedicalProfileUpdateModel>[].obs;
  final RxMap<int, AppointmentModel> _appointments =
      <int, AppointmentModel>{}.obs;
  final Map<int, Future<AppointmentModel?>> _appointmentRequests = {};

  String? get currentUserId {
    if (!Get.isRegistered<AuthController>()) return null;
    return Get.find<AuthController>().currentUser.value?.id;
  }

  @override
  void onInit() {
    super.onInit();
    fetchUpdates();
  }

  Future<void> fetchUpdates() async {
    if (isLoading.value) return;
    try {
      isLoading.value = true;
      errorMessage.value = null;
      final result = await _repository.getMedicalProfileUpdates();
      updates.assignAll(result);
    } catch (_) {
      errorMessage.value = 'Unable to load profile updates. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<AppointmentModel?> appointmentForId(int appointmentId) {
    if (appointmentId <= 0) return Future.value(null);
    final cached = _appointments[appointmentId];
    if (cached != null) return Future.value(cached);
    final pending = _appointmentRequests[appointmentId];
    if (pending != null) return pending;
    late final Future<AppointmentModel?> request;
    request = _loadAppointment(appointmentId).whenComplete(() {
      _appointmentRequests.remove(appointmentId);
    });
    _appointmentRequests[appointmentId] = request;
    return request;
  }

  Future<AppointmentModel?> _loadAppointment(int appointmentId) async {
    try {
      final data = await _repository.getAppointmentById(appointmentId);
      if (data == null) return null;
      final appointment = AppointmentModel.fromJson(data);
      _appointments[appointmentId] = appointment;
      return appointment;
    } catch (_) {
      return null;
    }
  }
}
