import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabibi/features/auth/repository/auth_repository.dart';
import 'package:tabibi/features/queue/controller/patient_queue_state_controller.dart';
import 'package:tabibi/features/queue/model/patient_queue_model.dart';
import 'package:tabibi/features/queue/repository/patient_queue_repository.dart';

Map<String, dynamic> queueResponse({
  String status = 'waiting',
  String priorityGroup = 'normal',
  int? currentPosition = 2,
  int? patientsAhead = 1,
  int? expectedWaitingTimeMinutes = 20,
  int? patientDelayMinutes = 4,
  String? checkInAt = '2026-08-20T08:30:00.000Z',
  String? calledAt,
  String? consultationStartedAt,
  String? completedAt,
  String? skippedAt,
  int? actualConsultationDurationMinutes,
}) {
  return {
    'id': 11,
    'appointmentId': 21,
    'clinicId': 31,
    'doctorId': 41,
    'currentPosition': currentPosition,
    'patientsAhead': patientsAhead,
    'priorityGroup': priorityGroup,
    'status': status,
    'checkInAt': checkInAt,
    'calledAt': calledAt,
    'consultationStartedAt': consultationStartedAt,
    'completedAt': completedAt,
    'skippedAt': skippedAt,
    'expectedWaitingTimeMinutes': expectedWaitingTimeMinutes,
    'patientDelayMinutes': patientDelayMinutes,
    'actualConsultationDurationMinutes': actualConsultationDurationMinutes,
    'clinic': {'id': 31, 'name': 'Central Clinic'},
    'doctor': {
      'id': 41,
      'fullName': 'Dr. Maha Saleh',
      'specialization': 'Cardiology',
    },
    'appointment': {
      'id': 21,
      'requestedDate': '2026-08-20T00:00:00.000Z',
      'startTime': '09:00',
      'endTime': '09:30',
      'type': 'consultation',
      'status': 'confirmed',
      'patient': {'id': 51, 'fullName': 'Patient Name'},
    },
  };
}

class _FakePatientQueueRepository extends PatientQueueRepository {
  _FakePatientQueueRepository({
    required this.activeRequest,
    required this.liveRequest,
  }) : super(AuthRepository(), client: Dio());

  final Future<PatientQueueModel?> Function() activeRequest;
  final Future<PatientQueueModel?> Function(int appointmentId) liveRequest;

  @override
  Future<PatientQueueModel?> getPatientActiveQueue() => activeRequest();

  @override
  Future<PatientQueueModel?> getPatientLiveStatus(int appointmentId) =>
      liveRequest(appointmentId);
}

void main() {
  group('PatientQueueModel', () {
    test('parses WAITING with canonical active metrics', () {
      final queue = PatientQueueModel.fromJson(queueResponse());

      expect(queue.status, PatientQueueStatus.waiting);
      expect(queue.priorityGroup, PatientQueuePriorityGroup.normal);
      expect(queue.currentPosition, 2);
      expect(queue.patientsAhead, 1);
      expect(queue.expectedWaitingTimeMinutes, 20);
      expect(queue.patientDelayMinutes, 4);
      expect(queue.calledAt, isNull);
    });

    test('parses CALLING and IN_PROGRESS backend status strings exactly', () {
      final calling = PatientQueueModel.fromJson(
        queueResponse(status: 'calling', calledAt: '2026-08-20T08:55:00.000Z'),
      );
      final inProgress = PatientQueueModel.fromJson(
        queueResponse(
          status: 'in_progress',
          consultationStartedAt: '2026-08-20T09:00:00.000Z',
          patientDelayMinutes: null,
        ),
      );

      expect(calling.status, PatientQueueStatus.calling);
      expect(calling.calledAt, isNotNull);
      expect(inProgress.status, PatientQueueStatus.inProgress);
      expect(inProgress.consultationStartedAt, isNotNull);
      expect(inProgress.patientDelayMinutes, isNull);
    });

    test('preserves nullable terminal metrics and timestamps', () {
      final completed = PatientQueueModel.fromJson(
        queueResponse(
          status: 'completed',
          currentPosition: null,
          patientsAhead: null,
          expectedWaitingTimeMinutes: null,
          patientDelayMinutes: null,
          completedAt: '2026-08-20T09:30:00.000Z',
          actualConsultationDurationMinutes: 30,
        ),
      );
      final skipped = PatientQueueModel.fromJson(
        queueResponse(
          status: 'skipped',
          currentPosition: null,
          patientsAhead: null,
          expectedWaitingTimeMinutes: null,
          patientDelayMinutes: null,
          skippedAt: '2026-08-20T09:05:00.000Z',
        ),
      );

      expect(completed.status, PatientQueueStatus.completed);
      expect(completed.currentPosition, isNull);
      expect(completed.actualConsultationDurationMinutes, 30);
      expect(skipped.status, PatientQueueStatus.skipped);
      expect(skipped.skippedAt, isNotNull);
      expect(skipped.expectedWaitingTimeMinutes, isNull);
    });

    test('parses both canonical priority groups', () {
      expect(
        PatientQueueModel.fromJson(
          queueResponse(priorityGroup: 'normal'),
        ).priorityGroup,
        PatientQueuePriorityGroup.normal,
      );
      expect(
        PatientQueueModel.fromJson(
          queueResponse(priorityGroup: 'late'),
        ).priorityGroup,
        PatientQueuePriorityGroup.late,
      );
    });

    test('rejects non-canonical Queue statuses without legacy fallback', () {
      expect(
        () => PatientQueueModel.fromJson(queueResponse(status: 'expired')),
        throwsFormatException,
      );
      expect(
        () => PatientQueueModel.fromJson(queueResponse(status: 'no_show')),
        throwsFormatException,
      );
    });
  });

  group('PatientQueueStateController', () {
    test(
      'maps the active endpoint no-Queue result to an empty state',
      () async {
        final controller = PatientQueueStateController(
          _FakePatientQueueRepository(
            activeRequest: () async => null,
            liveRequest: (_) async => null,
          ),
        );

        await controller.loadActiveQueue();

        expect(controller.loadState.value, PatientQueueLoadState.empty);
        expect(controller.activeQueue.value, isNull);
        expect(controller.failure.value, isNull);
      },
    );

    test('maps live-status ownership failure to an error state', () async {
      final controller = PatientQueueStateController(
        _FakePatientQueueRepository(
          activeRequest: () async => null,
          liveRequest: (_) async => throw const PatientQueueRepositoryException(
            kind: PatientQueueFailureKind.forbidden,
            statusCode: 403,
          ),
        ),
      );

      await controller.loadLiveStatus(21);

      expect(controller.loadState.value, PatientQueueLoadState.error);
      expect(controller.failure.value?.kind, PatientQueueFailureKind.forbidden);
    });
  });

  group('PatientQueueRepository endpoint semantics', () {
    Dio rejectingClient(int statusCode) {
      final client = Dio();
      client.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.reject(
              DioException(
                requestOptions: options,
                response: Response(
                  requestOptions: options,
                  statusCode: statusCode,
                ),
              ),
            );
          },
        ),
      );
      return client;
    }

    test('maps active Queue 404 to no active Queue', () async {
      final repository = PatientQueueRepository(
        AuthRepository(),
        client: rejectingClient(404),
      );

      expect(await repository.getPatientActiveQueue(), isNull);
    });

    test('preserves live-status 403 as a permission failure', () async {
      final repository = PatientQueueRepository(
        AuthRepository(),
        client: rejectingClient(403),
      );

      await expectLater(
        repository.getPatientLiveStatus(21),
        throwsA(
          isA<PatientQueueRepositoryException>().having(
            (error) => error.kind,
            'kind',
            PatientQueueFailureKind.forbidden,
          ),
        ),
      );
    });
  });

  group('PatientQueueRepositoryException', () {
    test('maps 401, 403, server, and network failures explicitly', () {
      DioException responseError(int statusCode) => DioException(
        requestOptions: RequestOptions(path: '/queues/patient/my-active-queue'),
        response: Response(
          requestOptions: RequestOptions(
            path: '/queues/patient/my-active-queue',
          ),
          statusCode: statusCode,
        ),
      );

      expect(
        PatientQueueRepositoryException.fromDio(responseError(401)).kind,
        PatientQueueFailureKind.unauthorized,
      );
      expect(
        PatientQueueRepositoryException.fromDio(responseError(403)).kind,
        PatientQueueFailureKind.forbidden,
      );
      expect(
        PatientQueueRepositoryException.fromDio(responseError(500)).kind,
        PatientQueueFailureKind.server,
      );
      expect(
        PatientQueueRepositoryException.fromDio(
          DioException(
            requestOptions: RequestOptions(
              path: '/queues/patient/my-active-queue',
            ),
            type: DioExceptionType.connectionError,
          ),
        ).kind,
        PatientQueueFailureKind.network,
      );
    });
  });
}
