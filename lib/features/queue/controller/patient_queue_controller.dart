import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:tabibi/features/auth/repository/auth_repository.dart';
import 'package:tabibi/features/queue/model/queue_patient.dart';

class PatientQueueController extends GetxController {
  PatientQueueController(this._authRepository);

  final AuthRepository _authRepository;
  final activeQueue = Rxn<QueuePatient>();
  final searchQuery = ''.obs;
  final selectedStatus = Rxn<QueuePatientStatus>();
  final selectedSort = QueueSort.positionAscending.obs;
  final now = DateTime.now().obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  Timer? _clock;
  Timer? _poll;

  @override
  void onInit() {
    super.onInit();
    _clock = Timer.periodic(
      const Duration(seconds: 30),
      (_) => now.value = DateTime.now(),
    );
    fetchLiveStatus();
    _poll = Timer.periodic(
      const Duration(seconds: 30),
      (_) => fetchLiveStatus(silent: true),
    );
  }

  @override
  void onClose() {
    _clock?.cancel();
    _poll?.cancel();
    super.onClose();
  }

  QueuePatient? get currentAppointment => activeQueue.value;
  int get patientsAhead => ((activeQueue.value?.position ?? 1) - 1).clamp(0, 999);

  List<QueuePatient> get visibleAppointments {
    final queue = activeQueue.value;
    if (queue == null) return const [];
    final query = searchQuery.value.trim().toLowerCase();
    final matchesStatus =
        selectedStatus.value == null || queue.status == selectedStatus.value;
    final matchesSearch =
        query.isEmpty ||
        queue.doctorName.toLowerCase().contains(query) ||
        queue.clinicName.toLowerCase().contains(query) ||
        queue.appointmentId.toLowerCase().contains(query);
    return matchesStatus && matchesSearch ? [queue] : const [];
  }

  void updateSearch(String value) => searchQuery.value = value;
  void selectStatus(QueuePatientStatus? value) => selectedStatus.value = value;
  void changeSort(QueueSort value) => selectedSort.value = value;

  Future<void> fetchLiveStatus({bool silent = false}) async {
    if (!silent) isLoading.value = true;

    try {
      final response = await _authRepository.dio.get(
        '/queues/patient/my-active-queue',
      );
      final body = response.data;
      if (body is! Map) {
        throw const FormatException('Invalid active queue response.');
      }
      activeQueue.value = QueuePatient.fromJson(Map<String, dynamic>.from(body));
      errorMessage.value = '';
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        activeQueue.value = null;
        errorMessage.value = '';
      } else if (!silent) {
        errorMessage.value = 'Unable to load your live queue status.';
      }
    } catch (_) {
      if (!silent) {
        errorMessage.value = 'Unable to load your live queue status.';
      }
    } finally {
      if (!silent) isLoading.value = false;
    }
  }
}
