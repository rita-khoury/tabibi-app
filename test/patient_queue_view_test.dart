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
    appointment: null,
  );
}

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
    expect(find.text('لا يوجد لديك طابور فعال حاليًا'), findsOneWidget);
  });

  testWidgets(
    'renders WAITING with backend position, ahead, ETA, and normal group',
    (tester) async {
      await pumpQueue(tester, () async => queue(patientDelayMinutes: 5));

      expect(find.byKey(const Key('queue-waiting')), findsOneWidget);
      expect(find.text('#2'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('20 د'), findsOneWidget);
      expect(find.text('عادي'), findsOneWidget);
      expect(find.text('متأخر عن موعدك بـ 5 دقائق'), findsOneWidget);
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

    expect(find.text('متأخر'), findsOneWidget);
    expect(find.textContaining('متأخر عن موعدك'), findsNothing);
  });

  testWidgets(
    'renders CALLING as the patient-turn state without waiting metrics',
    (tester) async {
      await pumpQueue(
        tester,
        () async => queue(status: PatientQueueStatus.calling),
      );

      expect(find.byKey(const Key('queue-calling')), findsOneWidget);
      expect(find.text('حان دورك'), findsOneWidget);
      expect(find.text('يرجى التوجه إلى الطبيب'), findsOneWidget);
      expect(find.text('موقعك'), findsNothing);
      expect(find.text('الانتظار'), findsNothing);
    },
  );

  testWidgets('renders IN_PROGRESS without waiting metrics', (tester) async {
    await pumpQueue(
      tester,
      () async => queue(status: PatientQueueStatus.inProgress),
    );

    expect(find.byKey(const Key('queue-in-progress')), findsOneWidget);
    expect(find.text('أنت الآن مع الطبيب'), findsOneWidget);
    expect(find.text('موقعك'), findsNothing);
    expect(find.text('أمامك'), findsNothing);
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
