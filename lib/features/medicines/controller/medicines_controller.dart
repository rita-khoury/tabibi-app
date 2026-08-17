import 'package:get/get.dart';
import 'package:tabibi/features/appointments/model/appointment_model.dart';
import 'package:tabibi/features/auth/data/models/DoctorModel.dart';
import 'package:tabibi/features/auth/repository/AuthController.dart';
import 'package:tabibi/features/auth/repository/auth_repository.dart';
import 'package:tabibi/features/medicines/model/prescribed_medicine_model.dart';

class MedicinesController extends GetxController {
  final AuthRepository _repository = AuthRepository();

  final isLoading = false.obs;
  final isSaving = false.obs;
  final errorMessage = RxnString();
  final profileMedicines = <PrescribedMedicineModel>[].obs;
  final historyMedicines = <PrescribedMedicineModel>[].obs;
  final updatingMedicineIds = <int>{}.obs;
  final RxMap<int, AppointmentModel> _appointments =
      <int, AppointmentModel>{}.obs;
  final RxMap<int, DoctorModel> _doctors = <int, DoctorModel>{}.obs;
  final Map<int, Future<AppointmentModel?>> _appointmentRequests = {};
  final Map<int, Future<DoctorModel?>> _doctorRequests = {};

  String? get currentUserId {
    if (!Get.isRegistered<AuthController>()) return null;
    return Get.find<AuthController>().currentUser.value?.id;
  }

  @override
  void onInit() {
    super.onInit();
    fetchMedicines();
  }

  bool isOwnedByCurrentPatient(PrescribedMedicineModel medicine) {
    final userId = currentUserId?.trim();
    return userId != null &&
        userId.isNotEmpty &&
        medicine.userId.toString() == userId;
  }

  Future<void> fetchMedicines() async {
    if (isLoading.value) return;
    try {
      isLoading.value = true;
      errorMessage.value = null;
      final data = await _repository.getMyMedicinesGrouped();
      profileMedicines.assignAll(data['profileMedicines'] ?? const []);
      historyMedicines.assignAll(data['historyMedicines'] ?? const []);
      await _preloadRelatedVisits(historyMedicines);
    } catch (error) {
      errorMessage.value = _friendlyError(error);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _preloadRelatedVisits(
    Iterable<PrescribedMedicineModel> medicines,
  ) async {
    final appointmentIds = <int>{};
    final doctorIds = <int>{};
    for (final medicine in medicines) {
      final history = medicine.medicalHistory;
      if (history == null) continue;
      final appointmentId = int.tryParse(
        history['appointmentId']?.toString() ?? '',
      );
      final doctorId = int.tryParse(
        history['doctorProfileId']?.toString() ?? '',
      );
      if (appointmentId != null && appointmentId > 0) {
        appointmentIds.add(appointmentId);
      }
      if (doctorId != null && doctorId > 0) doctorIds.add(doctorId);
    }
    await Future.wait<void>([
      ...appointmentIds.map((id) async {
        await appointmentForId(id);
      }),
      ...doctorIds.map((id) async {
        await doctorForId(id);
      }),
    ]);
  }

  int? appointmentIdFor(PrescribedMedicineModel medicine) {
    return int.tryParse(
      medicine.medicalHistory?['appointmentId']?.toString() ?? '',
    );
  }

  int? doctorIdFor(PrescribedMedicineModel medicine) {
    return int.tryParse(
      medicine.medicalHistory?['doctorProfileId']?.toString() ?? '',
    );
  }

  AppointmentModel? cachedAppointmentFor(PrescribedMedicineModel medicine) {
    final id = appointmentIdFor(medicine);
    return id == null ? null : _appointments[id];
  }

  DoctorModel? cachedDoctorFor(PrescribedMedicineModel medicine) {
    final id = doctorIdFor(medicine);
    return id == null ? null : _doctors[id];
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

  Future<DoctorModel?> doctorForId(int doctorId) {
    if (doctorId <= 0) return Future.value(null);
    final cached = _doctors[doctorId];
    if (cached != null) return Future.value(cached);
    final pending = _doctorRequests[doctorId];
    if (pending != null) return pending;
    late final Future<DoctorModel?> request;
    request = _loadDoctor(doctorId).whenComplete(() {
      _doctorRequests.remove(doctorId);
    });
    _doctorRequests[doctorId] = request;
    return request;
  }

  Future<DoctorModel?> _loadDoctor(int doctorId) async {
    try {
      final doctor = await _repository.getDoctorById(doctorId);
      if (doctor != null) _doctors[doctorId] = doctor;
      return doctor;
    } catch (_) {
      return null;
    }
  }

  Future<bool> addProfileMedicine(Map<String, dynamic> payload) async {
    if (isSaving.value) return false;
    try {
      isSaving.value = true;
      final medicine = await _repository.createMyProfileMedicineForPatient(
        payload,
      );
      profileMedicines.insert(0, medicine);
      return true;
    } catch (error) {
      errorMessage.value = _friendlyError(error);
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<bool> updateStatus(
    PrescribedMedicineModel medicine,
    String status,
  ) async {
    if (updatingMedicineIds.contains(medicine.id)) return false;
    try {
      updatingMedicineIds.add(medicine.id);
      final updated = await _repository.updatePatientMedicineStatus(
        medicine.id,
        status,
      );
      _replaceMedicine(updated);
      return true;
    } catch (error) {
      errorMessage.value = _friendlyError(error);
      return false;
    } finally {
      updatingMedicineIds.remove(medicine.id);
    }
  }

  void _replaceMedicine(PrescribedMedicineModel updated) {
    final target = updated.medicalHistoryId == null
        ? profileMedicines
        : historyMedicines;
    final index = target.indexWhere((medicine) => medicine.id == updated.id);
    if (index >= 0) target[index] = updated;
  }

  String _friendlyError(Object error) {
    final text = error.toString().replaceFirst('Exception: ', '').trim();
    return text.isEmpty ? 'Unable to complete this medicine request.' : text;
  }
}
