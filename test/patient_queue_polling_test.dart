import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabibi/features/auth/repository/auth_repository.dart';
import 'package:tabibi/features/queue/controller/patient_queue_state_controller.dart';
import 'package:tabibi/features/queue/model/patient_queue_model.dart';
import 'package:tabibi/features/queue/repository/patient_queue_repository.dart';

class _FakePatientQueueRepository extends PatientQueueRepository {
  _FakePatientQueueRepository(this.activeRequest)
    : super(AuthRepository(), client: Dio());

  final Future<PatientQueueModel?> Function() activeRequest;

  @override
  Future<PatientQueueModel?> getPatientActiveQueue() => activeRequest();
}

PatientQueueModel _queue(PatientQueueStatus status) {
  return PatientQueueModel(
    id: 1,
    appointmentId: 2,
    clinicId: 3,
    doctorId: 4,
    currentPosition: 2,
    patientsAhead: 1,
    priorityGroup: PatientQueuePriorityGroup.normal,
    status: status,
    checkInAt: DateTime.utc(2026, 8, 20, 8, 30),
    calledAt: status == PatientQueueStatus.calling
        ? DateTime.utc(2026, 8, 20, 8, 55)
        : null,
    consultationStartedAt: status == PatientQueueStatus.inProgress
        ? DateTime.utc(2026, 8, 20, 9)
        : null,
    completedAt: status == PatientQueueStatus.completed
        ? DateTime.utc(2026, 8, 20, 9, 30)
        : null,
    skippedAt: status == PatientQueueStatus.skipped
        ? DateTime.utc(2026, 8, 20, 9, 5)
        : null,
    expectedWaitingTimeMinutes: 20,
    patientDelayMinutes: null,
    actualConsultationDurationMinutes: null,
    clinic: null,
    doctor: null,
    appointment: null,
  );
}

Future<void> _advancePoll(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 5));
  await tester.pump();
}

void main() {
  testWidgets(
    'starts one poll after an active Queue load and updates its status',
    (tester) async {
      final responses = <PatientQueueModel?>[
        _queue(PatientQueueStatus.waiting),
        _queue(PatientQueueStatus.calling),
        _queue(PatientQueueStatus.inProgress),
      ];
      var requests = 0;
      final controller = PatientQueueStateController(
        _FakePatientQueueRepository(() async => responses[requests++]),
      );

      await controller.activateQueueScreen();
      expect(controller.isPolling, isTrue);
      expect(controller.activeQueue.value?.status, PatientQueueStatus.waiting);

      await _advancePoll(tester);
      expect(controller.activeQueue.value?.status, PatientQueueStatus.calling);

      await _advancePoll(tester);
      expect(
        controller.activeQueue.value?.status,
        PatientQueueStatus.inProgress,
      );
      controller.deactivateQueueScreen();
    },
  );

  testWidgets('does not poll when the active Queue endpoint returns null', (
    tester,
  ) async {
    var requests = 0;
    final controller = PatientQueueStateController(
      _FakePatientQueueRepository(() async {
        requests++;
        return null;
      }),
    );

    await controller.activateQueueScreen();
    await _advancePoll(tester);

    expect(controller.loadState.value, PatientQueueLoadState.empty);
    expect(controller.isPolling, isFalse);
    expect(requests, 1);
  });

  testWidgets('polling null response clears Queue, reaches empty, and stops', (
    tester,
  ) async {
    final responses = <PatientQueueModel?>[
      _queue(PatientQueueStatus.waiting),
      null,
    ];
    var requests = 0;
    final controller = PatientQueueStateController(
      _FakePatientQueueRepository(() async => responses[requests++]),
    );

    await controller.activateQueueScreen();
    await _advancePoll(tester);

    expect(controller.activeQueue.value, isNull);
    expect(controller.loadState.value, PatientQueueLoadState.empty);
    expect(controller.isPolling, isFalse);
  });

  testWidgets('terminal Queue polling response becomes empty and stops', (
    tester,
  ) async {
    final responses = <PatientQueueModel?>[
      _queue(PatientQueueStatus.waiting),
      _queue(PatientQueueStatus.completed),
    ];
    var requests = 0;
    final controller = PatientQueueStateController(
      _FakePatientQueueRepository(() async => responses[requests++]),
    );

    await controller.activateQueueScreen();
    await _advancePoll(tester);

    expect(controller.loadState.value, PatientQueueLoadState.empty);
    expect(controller.activeQueue.value, isNull);
    expect(controller.isPolling, isFalse);
  });

  testWidgets('temporary polling failure preserves the last active Queue', (
    tester,
  ) async {
    var requests = 0;
    final controller = PatientQueueStateController(
      _FakePatientQueueRepository(() async {
        requests++;
        if (requests == 1) return _queue(PatientQueueStatus.waiting);
        throw const PatientQueueRepositoryException(
          kind: PatientQueueFailureKind.network,
        );
      }),
    );

    await controller.activateQueueScreen();
    await _advancePoll(tester);

    expect(controller.loadState.value, PatientQueueLoadState.loaded);
    expect(controller.activeQueue.value?.status, PatientQueueStatus.waiting);
    expect(
      controller.refreshFailure.value?.kind,
      PatientQueueFailureKind.network,
    );
    expect(controller.isPolling, isTrue);
    controller.deactivateQueueScreen();
  });

  testWidgets(
    'repeated activation and manual refresh do not create duplicate timers',
    (tester) async {
      var requests = 0;
      final controller = PatientQueueStateController(
        _FakePatientQueueRepository(() async {
          requests++;
          return _queue(PatientQueueStatus.waiting);
        }),
      );

      await controller.activateQueueScreen();
      await controller.activateQueueScreen();
      await controller.loadActiveQueue();
      expect(controller.isPolling, isTrue);
      expect(requests, 3);

      await _advancePoll(tester);
      expect(requests, 4);
      controller.deactivateQueueScreen();
    },
  );

  testWidgets('deactivation and controller disposal cancel active polling', (
    tester,
  ) async {
    var requests = 0;
    final controller = PatientQueueStateController(
      _FakePatientQueueRepository(() async {
        requests++;
        return _queue(PatientQueueStatus.waiting);
      }),
    );

    await controller.activateQueueScreen();
    controller.deactivateQueueScreen();
    await _advancePoll(tester);
    expect(requests, 1);

    await controller.activateQueueScreen();
    expect(controller.isPolling, isTrue);
    controller.onClose();
    await _advancePoll(tester);
    expect(controller.isPolling, isFalse);
    expect(requests, 2);
  });
}
