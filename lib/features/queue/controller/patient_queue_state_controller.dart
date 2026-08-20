import 'dart:async';

import 'package:get/get.dart';
import 'package:tabibi/features/queue/model/patient_queue_model.dart';
import 'package:tabibi/features/queue/repository/patient_queue_repository.dart';

enum PatientQueueLoadState { initial, loading, loaded, empty, error }

class PatientQueueStateController extends GetxController {
  PatientQueueStateController(
    this._repository, {
    Duration pollingInterval = const Duration(seconds: 5),
  }) : _pollingInterval = pollingInterval;

  final PatientQueueRepository _repository;
  final Duration _pollingInterval;
  Timer? _pollingTimer;
  bool _isQueueScreenActive = false;
  bool _isPollRequestInFlight = false;

  final loadState = PatientQueueLoadState.initial.obs;
  final activeQueue = Rxn<PatientQueueModel>();
  final failure = Rxn<PatientQueueRepositoryException>();
  final refreshFailure = Rxn<PatientQueueRepositoryException>();

  bool get isPolling => _pollingTimer?.isActive ?? false;

  Future<void> activateQueueScreen() async {
    _isQueueScreenActive = true;
    await loadActiveQueue();
  }

  void deactivateQueueScreen() {
    _isQueueScreenActive = false;
    stopPolling();
  }

  Future<void> loadActiveQueue() async {
    await _loadActiveQueue(isPollingRequest: false);
  }

  Future<void> loadLiveStatus(int appointmentId) async {
    await _load(
      () => _repository.getPatientLiveStatus(appointmentId),
      isPollingRequest: false,
      startPollingOnActiveQueue: false,
    );
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  @override
  void onClose() {
    stopPolling();
    super.onClose();
  }

  Future<void> _loadActiveQueue({required bool isPollingRequest}) async {
    await _load(
      _repository.getPatientActiveQueue,
      isPollingRequest: isPollingRequest,
      startPollingOnActiveQueue: true,
    );
  }

  Future<void> _load(
    Future<PatientQueueModel?> Function() request, {
    required bool isPollingRequest,
    required bool startPollingOnActiveQueue,
  }) async {
    final previousQueue = activeQueue.value;
    final preserveVisibleQueue = isPollingRequest && previousQueue != null;

    if (!preserveVisibleQueue) {
      loadState.value = PatientQueueLoadState.loading;
    }
    if (!isPollingRequest) {
      refreshFailure.value = null;
    }
    failure.value = null;

    try {
      final queue = await request();
      if (!_isActiveQueue(queue)) {
        activeQueue.value = null;
        loadState.value = PatientQueueLoadState.empty;
        refreshFailure.value = null;
        stopPolling();
        return;
      }

      activeQueue.value = queue;
      loadState.value = PatientQueueLoadState.loaded;
      refreshFailure.value = null;
      if (startPollingOnActiveQueue) {
        _startPollingIfNeeded();
      }
    } on PatientQueueRepositoryException catch (error) {
      if (preserveVisibleQueue && _isTransientFailure(error)) {
        activeQueue.value = previousQueue;
        loadState.value = PatientQueueLoadState.loaded;
        refreshFailure.value = error;
        return;
      }

      activeQueue.value = null;
      failure.value = error;
      loadState.value = PatientQueueLoadState.error;
      stopPolling();
    } catch (_) {
      const error = PatientQueueRepositoryException(
        kind: PatientQueueFailureKind.unknown,
      );
      if (preserveVisibleQueue) {
        activeQueue.value = previousQueue;
        loadState.value = PatientQueueLoadState.loaded;
        refreshFailure.value = error;
        return;
      }

      activeQueue.value = null;
      failure.value = error;
      loadState.value = PatientQueueLoadState.error;
      stopPolling();
    }
  }

  void _startPollingIfNeeded() {
    if (!_isQueueScreenActive || !_isActiveQueue(activeQueue.value)) {
      stopPolling();
      return;
    }
    if (_pollingTimer?.isActive ?? false) return;

    stopPolling();
    _pollingTimer = Timer.periodic(_pollingInterval, (_) => _poll());
  }

  Future<void> _poll() async {
    if (!_isQueueScreenActive || _isPollRequestInFlight) return;

    _isPollRequestInFlight = true;
    try {
      await _loadActiveQueue(isPollingRequest: true);
    } finally {
      _isPollRequestInFlight = false;
    }
  }

  bool _isActiveQueue(PatientQueueModel? queue) {
    return queue != null &&
        switch (queue.status) {
          PatientQueueStatus.waiting ||
          PatientQueueStatus.calling ||
          PatientQueueStatus.inProgress => true,
          PatientQueueStatus.completed || PatientQueueStatus.skipped => false,
        };
  }

  bool _isTransientFailure(PatientQueueRepositoryException error) {
    return error.kind == PatientQueueFailureKind.network ||
        error.kind == PatientQueueFailureKind.server;
  }
}
