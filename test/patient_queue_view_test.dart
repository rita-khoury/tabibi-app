import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tabibi/features/auth/repository/auth_repository.dart';
import 'package:tabibi/features/queue/controller/patient_queue_state_controller.dart';
import 'package:tabibi/features/queue/model/patient_queue_model.dart';
import 'package:tabibi/features/queue/repository/patient_queue_repository.dart';
import 'package:tabibi/features/queue/view/patient_queue_view.dart';

class _FakePatientQueueRepository extends PatientQueueRepository {
  _FakePatientQueueRepository(this.activeRequest)
    : super(AuthRepository(), client: Dio());

  final Future<PatientQueueModel?> Function() activeRequest;

  @override
  Future<PatientQueueModel?> getPatientActiveQueue() => activeRequest();
}

PatientQueueModel queue({
  PatientQueueStatus status = PatientQueueStatus.waiting,
  PatientQueuePriorityGroup priorityGroup = PatientQueuePriorityGroup.normal,
  int? currentPosition = 2,
  int? patientsAhead = 1,
  int? expectedWaitingTimeMinutes = 20,
  int? patientDelayMinutes,
  DateTime? checkInAt,
  DateTime? calledAt,
  PatientQueueAppointment? appointment,
}) {
  return PatientQueueModel(
    id: 1,
    appointmentId: 2,
    clinicId: 3,
    doctorId: 4,
    currentPosition: currentPosition,
    patientsAhead: patientsAhead,
    priorityGroup: priorityGroup,
    status: status,
    checkInAt: checkInAt ?? DateTime.utc(2026, 8, 20, 8, 30),
    calledAt:
        calledAt ??
        (status == PatientQueueStatus.calling
            ? DateTime.utc(2026, 8, 20, 8, 55)
            : null),
    consultationStartedAt: status == PatientQueueStatus.inProgress
        ? DateTime.utc(2026, 8, 20, 9)
        : null,
    completedAt: status == PatientQueueStatus.completed
        ? DateTime.utc(2026, 8, 20, 9, 30)
        : null,
    skippedAt: status == PatientQueueStatus.skipped
        ? DateTime.utc(2026, 8, 20, 9, 5)
        : null,
    expectedWaitingTimeMinutes: expectedWaitingTimeMinutes,
    patientDelayMinutes: patientDelayMinutes,
    actualConsultationDurationMinutes: status == PatientQueueStatus.completed
        ? 30
        : null,
    clinic: const PatientQueueClinic(id: 3, name: 'Central Clinic'),
    doctor: const PatientQueueDoctor(
      id: 4,
      fullName: 'Dr. Maha Saleh',
      specialization: 'Cardiology',
    ),
    appointment: appointment,
  );
}

final _appointment = PatientQueueAppointment(
  id: 2,
  requestedDate: DateTime(2026, 8, 20),
  startTime: '3:15 PM',
  endTime: '3:45 PM',
  type: 'consultation',
  status: 'confirmed',
  patient: null,
);

Future<void> pumpQueue(
  WidgetTester tester,
  Future<PatientQueueModel?> Function() activeRequest,
) async {
  Get.put(
    PatientQueueStateController(_FakePatientQueueRepository(activeRequest)),
  );
  await tester.pumpWidget(const GetMaterialApp(home: PatientQueueView()));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('ar');
  });

  setUp(() {
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('renders initial loading while the active request is pending', (
    tester,
  ) async {
    final completer = Completer<PatientQueueModel?>();

    Get.put(
      PatientQueueStateController(
        _FakePatientQueueRepository(() => completer.future),
      ),
    );
    await tester.pumpWidget(const GetMaterialApp(home: PatientQueueView()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    completer.complete(null);
  });

  testWidgets('renders the empty active Queue state for no Queue', (
    tester,
  ) async {
    await pumpQueue(tester, () async => null);

    expect(find.byKey(const Key('queue-empty')), findsOneWidget);
    expect(find.text('You currently have no active queue.'), findsOneWidget);
  });

  testWidgets('renders English appointment and check-in date/time text', (
    tester,
  ) async {
    await pumpQueue(
      tester,
      () async => queue(
        appointment: _appointment,
        checkInAt: DateTime(2026, 8, 20, 15, 02),
      ),
    );

    expect(find.text('Aug 20, 2026 · 3:15 PM'), findsOneWidget);
    expect(find.text('3:02 PM'), findsOneWidget);
    expect(find.textContaining('أغسطس'), findsNothing);
    expect(find.textContaining(' ص'), findsNothing);
    expect(find.textContaining(' م'), findsNothing);
  });

  testWidgets('renders English appointment and called time text', (
    tester,
  ) async {
    await pumpQueue(
      tester,
      () async => queue(
        status: PatientQueueStatus.calling,
        appointment: _appointment,
        calledAt: DateTime(2026, 8, 20, 15, 51),
      ),
    );

    expect(find.text('Aug 20, 2026 · 3:15 PM'), findsOneWidget);
    expect(find.text('Called: 3:51 PM'), findsOneWidget);
    expect(find.textContaining('أغسطس'), findsNothing);
    expect(find.textContaining(' ص'), findsNothing);
    expect(find.textContaining(' م'), findsNothing);
  });

  testWidgets(
    'renders WAITING with backend position, ahead, ETA, and normal group',
    (tester) async {
      await pumpQueue(tester, () async => queue(patientDelayMinutes: 5));

      expect(find.byKey(const Key('queue-waiting')), findsOneWidget);
      expect(find.text('#2'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('20 min'), findsOneWidget);
      expect(find.text('Normal'), findsOneWidget);
      expect(
        find.text('You are 5 minutes late for your appointment.'),
        findsOneWidget,
      );
    },
  );

  testWidgets('renders LATE and does not show a null delay warning', (
    tester,
  ) async {
    await pumpQueue(
      tester,
      () async => queue(
        priorityGroup: PatientQueuePriorityGroup.late,
        patientDelayMinutes: null,
      ),
    );

    expect(find.text('Late'), findsOneWidget);
    expect(find.textContaining('late for your appointment'), findsNothing);
  });

  testWidgets(
    'renders CALLING as the patient-turn state without waiting metrics',
    (tester) async {
      await pumpQueue(
        tester,
        () async => queue(status: PatientQueueStatus.calling),
      );

      expect(find.byKey(const Key('queue-calling')), findsOneWidget);
      expect(find.text("It's your turn"), findsOneWidget);
      expect(find.text('Please proceed to the doctor'), findsOneWidget);
      expect(find.text('Your position'), findsNothing);
      expect(find.text('Waiting'), findsNothing);
    },
  );

  testWidgets('renders IN_PROGRESS without waiting metrics', (tester) async {
    await pumpQueue(
      tester,
      () async => queue(status: PatientQueueStatus.inProgress),
    );

    expect(find.byKey(const Key('queue-in-progress')), findsOneWidget);
    expect(find.text('You are now with the doctor'), findsOneWidget);
    expect(find.text('Your position'), findsNothing);
    expect(find.text('Ahead of you'), findsNothing);
  });

  Future<void> expectTerminalQueueAsEmpty(
    WidgetTester tester,
    PatientQueueStatus status,
  ) async {
    await pumpQueue(
      tester,
      () async => queue(
        status: status,
        currentPosition: null,
        patientsAhead: null,
        expectedWaitingTimeMinutes: null,
      ),
    );

    expect(find.byKey(const Key('queue-empty')), findsOneWidget);
    expect(find.byKey(const Key('queue-waiting')), findsNothing);
    expect(find.byKey(const Key('queue-calling')), findsNothing);
    expect(find.byKey(const Key('queue-in-progress')), findsNothing);
  }

  testWidgets('renders COMPLETED as the active Queue empty state', (
    tester,
  ) async {
    await expectTerminalQueueAsEmpty(tester, PatientQueueStatus.completed);
  });

  testWidgets('renders SKIPPED as the active Queue empty state', (
    tester,
  ) async {
    await expectTerminalQueueAsEmpty(tester, PatientQueueStatus.skipped);
  });
}
