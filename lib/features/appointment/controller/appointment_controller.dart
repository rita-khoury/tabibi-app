// import 'package:audioplayers/audioplayers.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:intl/intl.dart';
// import 'package:tabibi/core/constance/app_colors.dart';
// import 'package:tabibi/features/auth/data/models/CreateAppointmentModel.dart';
import 'package:tabibi/features/auth/data/models/DoctorModel.dart';
// import 'package:tabibi/features/auth/repository/auth_repository.dart';
//
// import '../../../core/routes/app_routes.dart';
// import '../../appointments/controller/appointments_controller.dart';
import '../../navigation/controller/navigation_controller.dart';
//
// class AppointmentController extends GetxController {
//   final AuthRepository _repo = Get.find<AuthRepository>();
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   final GetStorage _box = GetStorage();
//
//   RxBool isLoading = false.obs;
//   var dontShowAgain = false.obs;
//   Rxn<dynamic> selectedReferral = Rxn<dynamic>();
//
//   DateTime selectedDate = DateTime.now();
//   String selectedPeriod = "";
//   String selectedType = "Initial Visit";
//   var availableClinics = <dynamic>[].obs;
//   var selectedClinicId = RxnInt();
//
//   var doctorWorkDays = <String>[].obs;
//   var doctorScheduleMap = <String, List<String>>{}.obs;
//   final Map<String, Map<String, String>> _periodStartTimeMap = {};
//   var availablePeriodsForSelectedDay = <String>[].obs;
//
//   final List<String> appointmentTypes = [
//     "Advice",
//     "Follow-up",
//     "NORMAL",
//     "Initial Visit",
//   ];
//
//   List<DateTime> get nextDays =>
//       List.generate(7, (i) => DateTime.now().add(Duration(days: i)));
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     bool savedPreference = _box.read('hideTerms') ?? false;
//     dontShowAgain.value = savedPreference;
//   }
//
//   @override
//   void onClose() {
//     _audioPlayer.dispose();
//     super.onClose();
//   }
//
//   void saveTermsPreference() {
//     _box.write('hideTerms', dontShowAgain.value);
//   }
//
//   List<DateTime> get doctorAvailableDays {
//     List<DateTime> validDays = [];
//     DateTime today = DateTime.now();
//     for (int i = 0; i < 14; i++) {
//       DateTime day = today.add(Duration(days: i));
//       String dayName = DateFormat('EEEE').format(day);
//       if (doctorWorkDays.contains(dayName)) {
//         validDays.add(day);
//       }
//     }
//     return validDays;
//   }
//
//   void selectDate(DateTime date) {
//     selectedDate = DateTime(date.year, date.month, date.day);
//     String dayName = DateFormat('EEEE').format(selectedDate);
//
//     if (doctorScheduleMap.containsKey(dayName)) {
//       List<String> periods = doctorScheduleMap[dayName]!;
//       availablePeriodsForSelectedDay.assignAll(periods);
//
//       if (!periods.contains(selectedPeriod)) {
//         selectedPeriod = periods.isNotEmpty ? periods.first : "";
//       }
//     } else {
//       availablePeriodsForSelectedDay.clear();
//       selectedPeriod = "";
//     }
//
//     update();
//   }
//
//   void selectPeriod(String period) {
//     if (availablePeriodsForSelectedDay.contains(period)) {
//       selectedPeriod = period;
//       update();
//     }
//   }
//
//   void selectType(String type) {
//     selectedType = type;
//     update();
//   }
//
//   void selectReferral(dynamic referral) {
//     selectedReferral.value = referral;
//     update();
//   }
//
//   String _getStartTime() {
//     String dayName = DateFormat('EEEE').format(selectedDate);
//
//     if (_periodStartTimeMap.containsKey(dayName) &&
//         _periodStartTimeMap[dayName]!.containsKey(selectedPeriod)) {
//       return _periodStartTimeMap[dayName]![selectedPeriod]!;
//     }
//
//     switch (selectedPeriod) {
//       case "Morning":
//         return "10:00:00";
//       case "Afternoon":
//         return "13:00:00";
//       case "Evening":
//         return "15:00:00";
//       default:
//         return "10:00:00";
//     }
//   }
//
//   String _getEndTime() {
//     try {
//       DateTime start = DateFormat("HH:mm:ss").parse(_getStartTime());
//       int duration = (selectedType == "Initial Visit") ? 30 : 20;
//       return DateFormat(
//         "HH:mm:ss",
//       ).format(start.add(Duration(minutes: duration)));
//     } catch (e) {
//       return "10:30:00";
//     }
//   }
//
//   Future<void> fetchClinics(int doctorId) async {
//     isLoading.value = true;
//     try {
//       var clinics = await _repo.getClinicsForDoctor(doctorId);
//       availableClinics.assignAll(clinics);
//
//       if (clinics.isNotEmpty) {
//         selectedClinicId.value = clinics.first.id;
//
//         int currentClinicId = selectedClinicId.value!;
//         var scheduleList = await _repo.getDoctorScheduleForPatient(
//           doctorId,
//           currentClinicId,
//         );
//
//         Map<String, List<String>> tempScheduleMap = {};
//         _periodStartTimeMap.clear();
//
//         final Map<int, String> dayOfWeekMap = {
//           0: "Sunday",
//           1: "Monday",
//           2: "Tuesday",
//           3: "Wednesday",
//           4: "Thursday",
//           5: "Friday",
//           6: "Saturday",
//         };
//
//         for (var item in scheduleList) {
//           var dayVal = item['dayOfWeek'] ?? item['day'];
//           int? dayIndex = dayVal is int
//               ? dayVal
//               : int.tryParse(dayVal?.toString() ?? '');
//
//           if (dayIndex != null && dayOfWeekMap.containsKey(dayIndex)) {
//             String dayName = dayOfWeekMap[dayIndex]!;
//             String startTime = item['startTime']?.toString() ?? "09:00:00";
//             String endTime = item['endTime']?.toString() ?? "17:00:00";
//
//             List<String> periods = [];
//
//             if (item['periods'] is List) {
//               periods = (item['periods'] as List)
//                   .map((p) => p.toString())
//                   .toList();
//             } else if (item['period'] != null || item['shiftName'] != null) {
//               periods.add(item['period'] ?? item['shiftName']);
//             } else {
//               int? startHour = int.tryParse(startTime.split(':').first);
//               int? endHour = int.tryParse(endTime.split(':').first);
//
//               if (startHour != null && endHour != null) {
//                 if (startHour < 12) {
//                   periods.add("Morning");
//                   _periodStartTimeMap.putIfAbsent(
//                     dayName,
//                     () => {},
//                   )["Morning"] = startTime;
//                 }
//                 if ((startHour < 17 && endHour > 12) ||
//                     (startHour >= 12 && startHour < 17)) {
//                   periods.add("Afternoon");
//                   String afternoonStart = (startHour >= 12 && startHour < 17)
//                       ? startTime
//                       : "13:00:00";
//                   _periodStartTimeMap.putIfAbsent(
//                     dayName,
//                     () => {},
//                   )["Afternoon"] = afternoonStart;
//                 }
//                 if (endHour >= 17 || startHour >= 17) {
//                   periods.add("Evening");
//                   String eveningStart = (startHour >= 17)
//                       ? startTime
//                       : "15:00:00";
//                   _periodStartTimeMap.putIfAbsent(
//                     dayName,
//                     () => {},
//                   )["Evening"] = eveningStart;
//                 }
//               }
//
//               if (periods.isEmpty) {
//                 periods.add("Morning");
//                 _periodStartTimeMap.putIfAbsent(dayName, () => {})["Morning"] =
//                     startTime;
//               }
//             }
//
//             if (tempScheduleMap.containsKey(dayName)) {
//               for (var p in periods) {
//                 if (!tempScheduleMap[dayName]!.contains(p)) {
//                   tempScheduleMap[dayName]!.add(p);
//                 }
//               }
//             } else {
//               tempScheduleMap[dayName] = periods;
//             }
//           }
//         }
//
//         doctorScheduleMap.value = tempScheduleMap;
//         doctorWorkDays.assignAll(doctorScheduleMap.keys.toList());
//
//         List<DateTime> availableDays = doctorAvailableDays;
//         if (availableDays.isNotEmpty) {
//           selectDate(availableDays.first);
//         } else {
//           availablePeriodsForSelectedDay.clear();
//         }
//       }
//     } catch (e) {
//       debugPrint("Error fetching clinics and schedule: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//
//   Future<void> submitAppointment({
//     required int doctorId,
//     required int clinicId,
//     int? referralId,
//   }) async {
//     isLoading.value = true;
//     try {
//       final completion = await _repo.getCompletionStatus();
//       if (!completion.completed) {
//         _showIncompleteProfileWarning();
//         return;
//       }
//
//       final appointment = CreateAppointmentModel(
//         doctorId: doctorId,
//         clinicId: clinicId,
//         requestedDate: DateFormat("yyyy-MM-dd").format(selectedDate),
//         startTime: _getStartTime(),
//         endTime: _getEndTime(),
//         type: selectedType,
//         priority: "1",
//         reasonForVisit: "General checkup",
//         referralId: referralId,
//       );
//
//       final success = await _repo.createAppointment(appointment);
//
//       if (success) {
//         if (Get.isRegistered<AppointmentsController>()) {
//           Get.find<AppointmentsController>().fetchAppointments();
//         }
//
//         await playSuccessEffect();
//         Get.back();
//       }
//     } on DioException catch (e) {
//       String errorMessage = e.response?.data['message'] ?? "";
//       int? statusCode = e.response?.statusCode;
//
//       if (errorMessage.contains("Patient profile not found") ||
//           statusCode == 404) {
//         _showIncompleteProfileWarning();
//         return;
//       }
//
//       if (statusCode == 400) {
//         bool isDayFull =
//             errorMessage.contains("full") ||
//             errorMessage.contains("fully booked") ||
//             errorMessage.contains("capacity") ||
//             errorMessage.contains("overlaps");
//
//         if (isDayFull) {
//           Get.defaultDialog(
//             title: "Day Fully Booked",
//             middleText:
//                 "Sorry, this day is fully booked. Would you like to join the waitlist?",
//             textConfirm: "Yes, add me",
//             textCancel: "Cancel",
//             confirmTextColor: Colors.white,
//             buttonColor: const Color(0xFF007BFF),
//             onConfirm: () async {
//               Get.back();
//               try {
//                 String formattedDate = DateFormat(
//                   "yyyy-MM-dd",
//                 ).format(selectedDate);
//                 bool waitlistSuccess = await _repo.joinWaitlist(
//                   doctorId: doctorId,
//                   clinicId: clinicId,
//                   requestedDate: formattedDate,
//                 );
//
//                 if (waitlistSuccess) {
//                   if (Get.isRegistered<AppointmentsController>()) {
//                     try {
//                       await Get.find<AppointmentsController>().fetchWaitlist();
//                     } catch (_) {}
//                   }
//
//                   Get.snackbar(
//                     "Success",
//                     "Successfully added to the waitlist",
//                     backgroundColor: Colors.green,
//                     colorText: Colors.white,
//                   );
//                 }
//               } on DioException catch (waitlistError) {
//                 String waitlistMsg =
//                     waitlistError.response?.data['message'] ??
//                     "Failed to join waitlist";
//                 Get.snackbar(
//                   "Notice",
//                   waitlistMsg,
//                   backgroundColor: Colors.orange,
//                   colorText: Colors.white,
//                 );
//               } catch (e) {
//                 Get.snackbar(
//                   "Error",
//                   "An error occurred while joining the waitlist",
//                   backgroundColor: Colors.red,
//                   colorText: Colors.white,
//                 );
//               }
//             },
//           );
//         } else {
//           Get.snackbar(
//             "Notice",
//             errorMessage.isNotEmpty
//                 ? errorMessage
//                 : "Sorry, unable to complete the booking at this time",
//             backgroundColor: Colors.orange,
//             colorText: Colors.white,
//           );
//         }
//       } else {
//         Get.snackbar(
//           "Error",
//           errorMessage.isNotEmpty ? errorMessage : "Connection error",
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//       }
//     } catch (e) {
//       if (e.toString().contains("Patient profile not found")) {
//         _showIncompleteProfileWarning();
//         return;
//       }
//
//       debugPrint("Detailed unexpected error: $e");
//       Get.snackbar(
//         "Error",
//         "An unexpected error occurred",
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   void _showIncompleteProfileWarning() {
//     Get.defaultDialog(
//       title: "",
//       titlePadding: EdgeInsets.zero,
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Icon(
//             Icons.warning_amber_rounded,
//             color: Colors.redAccent,
//             size: 54,
//           ),
//           const SizedBox(height: 12),
//           const Text(
//             "Incomplete Profile",
//             style: TextStyle(
//               color: Colors.redAccent,
//               fontWeight: FontWeight.bold,
//               fontSize: 20,
//             ),
//           ),
//           const SizedBox(height: 10),
//           const Text(
//             "Your medical profile is incomplete or missing!\nPlease complete your profile to proceed with booking appointments.",
//             textAlign: TextAlign.center,
//             style: TextStyle(color: Colors.black87, fontSize: 14, height: 1.5),
//           ),
//         ],
//       ),
//       backgroundColor: Colors.white,
//       radius: 16,
//       barrierDismissible: true,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       textCancel: "Skip",
//       cancelTextColor: Colors.grey.shade700,
//       onCancel: () {},
//       textConfirm: "Complete Profile",
//       confirmTextColor: Colors.white,
//       buttonColor: Colors.redAccent,
//       onConfirm: () {
//         Get.back();
//         Get.toNamed(AppRoutes.medicalProfile);
//       },
//     );
//   }
//
//   Future<void> checkProfileAndProceed(VoidCallback onCompleted) async {
//     isLoading.value = true;
//     try {
//       final completion = await _repo.getCompletionStatus();
//       if (!completion.completed) {
//         _showIncompleteProfileWarning();
//         return;
//       }
//
//       onCompleted();
//     } on DioException catch (e) {
//       if (e.response?.statusCode == 404 ||
//           (e.response?.data['message']?.toString().contains(
//                 "Patient profile not found",
//               ) ??
//               false)) {
//         _showIncompleteProfileWarning();
//       } else {
//         Get.snackbar(
//           "خطأ",
//           "حدث خطأ في الاتصال بالسرفر",
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//       }
//     } catch (e) {
//       if (e.toString().contains("Patient profile not found")) {
//         _showIncompleteProfileWarning();
//       } else {
//         Get.snackbar(
//           "خطأ",
//           "حدث خطأ غير متوقع",
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//       }
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> playSuccessEffect() async {
//     Get.snackbar(
//       "Success",
//       "Appointment created successfully",
//       backgroundColor: AppColors.primaryBlue,
//       colorText: Colors.white,
//     );
//     await _audioPlayer.play(AssetSource("sounds/notification_sound.mp3"));
//   }
// }

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:tabibi/features/auth/data/models/CreateAppointmentModel.dart';
import 'package:tabibi/features/auth/repository/auth_repository.dart';

import '../../../core/constance/app_messages.dart';
import '../../../core/constance/app_alerts.dart'; // استيراد ملف المساعدات والتنبيهات الموحدة
import '../../../core/routes/app_routes.dart';
import '../../appointments/controller/appointments_controller.dart';

class AppointmentController extends GetxController {
  final AuthRepository _repo = Get.find<AuthRepository>();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Rxn<DoctorModel> bookingSummaryDoctor = Rxn<DoctorModel>();
  final RxBool isBookingSummaryLoading = false.obs;
  final GetStorage _box = GetStorage();

  final RxBool isLoading = false.obs;
  final RxBool dontShowAgain = false.obs;
  final Rxn<dynamic> selectedReferral = Rxn<dynamic>();

  DateTime selectedDate = DateTime.now();
  String selectedPeriod = '';
  String selectedType = 'Initial Visit';

  final RxList<dynamic> availableClinics = <dynamic>[].obs;
  final RxnInt selectedClinicId = RxnInt();
  final RxList<Map<String, dynamic>> _availableDayRecords =
      <Map<String, dynamic>>[].obs;
  final RxMap<String, String> dayStatuses = <String, String>{}.obs;
  final RxSet<String> _unavailableSchedulePeriods = <String>{}.obs;

  final RxList<Map<String, dynamic>> selectedDateSchedules =
      <Map<String, dynamic>>[].obs;
  final RxList<String> availablePeriodsForSelectedDay = <String>[].obs;
  final RxMap<String, Map<String, dynamic>> _schedulesByLabel =
      <String, Map<String, dynamic>>{}.obs;
  final RxnInt selectedScheduleId = RxnInt();
  final RxList<Map<String, String>> availableTimeSlots =
      <Map<String, String>>[].obs;
  final Rxn<Map<String, String>> selectedTimeSlot = Rxn<Map<String, String>>();
  final RxString selectedDayStatus = ''.obs;
  final RxString waitlistMembershipState = 'idle'.obs;
  int _waitlistMembershipRequest = 0;

  final List<String> appointmentTypes = const ['Initial Visit', 'Return Visit'];

  bool _isInitializing = false;
  int? _loadedDoctorId;

  List<DateTime> get doctorAvailableDays => _availableDayRecords
      .map((record) => DateTime.tryParse(record['date']?.toString() ?? ''))
      .whereType<DateTime>()
      .map((date) => DateTime(date.year, date.month, date.day))
      .toList();

  bool get isSelectedDayFull => selectedDayStatus.value == 'full';
  bool get isCheckingWaitlistMembership =>
      waitlistMembershipState.value == 'loading';
  bool get isAlreadyOnWaitlist => waitlistMembershipState.value == 'joined';
  bool get hasWaitlistMembershipCheckFailed =>
      waitlistMembershipState.value == 'error';
  bool get canJoinWaitlist =>
      isSelectedDayFull &&
      selectedClinicId.value != null &&
      waitlistMembershipState.value == 'not_joined';
  bool get hasSelectedFinalTime =>
      selectedTimeSlot.value != null &&
      selectedPeriod.isNotEmpty &&
      !_unavailableSchedulePeriods.contains(selectedPeriod);

  Future<void> loadBookingSummaryDoctor(int doctorId) async {
    isBookingSummaryLoading.value = true;
    bookingSummaryDoctor.value = null;
    try {
      bookingSummaryDoctor.value = await _repo.getDoctorById(doctorId);
    } catch (_) {
      bookingSummaryDoctor.value = null;
    } finally {
      isBookingSummaryLoading.value = false;
      update();
    }
  }

  String get bookingSummaryRequestedDate =>
      DateFormat('yyyy-MM-dd').format(selectedDate);

  String get bookingSummaryTime {
    final slot = selectedTimeSlot.value;
    final startTime = slot?['startTime']?.trim() ?? '';
    final endTime = slot?['endTime']?.trim() ?? '';
    if (startTime.isEmpty || endTime.isEmpty) {
      return 'Time unavailable';
    }
    return '$startTime - $endTime';
  }

  String get bookingSummaryFee {
    final doctor = bookingSummaryDoctor.value;
    final fee = selectedType == 'Initial Visit'
        ? doctor?.initialVisitFee
        : doctor?.returnVisitFee;
    if (fee == null || fee.trim().isEmpty) {
      return 'Fee unavailable';
    }
    final amount = num.tryParse(fee);
    if (amount == null) {
      return '$fee S.P';
    }
    return '${NumberFormat('#,##0.##').format(amount)} S.P';
  }

  @override
  void onInit() {
    super.onInit();
    dontShowAgain.value = _box.read('hideTerms') ?? false;
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }

  void saveTermsPreference() {
    _box.write('hideTerms', dontShowAgain.value);
  }

  Future<void> fetchClinics(int doctorId) async {
    if (_isInitializing ||
        (_loadedDoctorId == doctorId && selectedClinicId.value != null)) {
      return;
    }

    _isInitializing = true;
    isLoading.value = true;
    try {
      final clinics = await _repo.getClinicsForDoctor(doctorId);
      availableClinics.assignAll(clinics);
      _loadedDoctorId = doctorId;

      if (clinics.isEmpty) {
        _clearBookingSelection();
        AppAlerts.showError(
          title: AppMessages.errorTitle,
          message: 'This doctor is not currently assigned to a clinic.',
        );
        return;
      }

      await selectClinic(doctorId, _asInt(clinics.first.id));
    } catch (error) {
      _clearBookingSelection();
      AppAlerts.showError(
        title: AppMessages.errorTitle,
        message: _messageFromError(error),
      );
    } finally {
      _isInitializing = false;
      isLoading.value = false;
      update();
    }
  }

  Future<void> selectClinic(int doctorId, int clinicId) async {
    final clinicExists = availableClinics.any(
      (clinic) => _asInt(clinic.id) == clinicId,
    );
    if (!clinicExists) {
      return;
    }

    selectedClinicId.value = clinicId;
    _clearDateDependentSelection();
    isLoading.value = true;
    try {
      final days = await _repo.getAvailableDays(doctorId, clinicId);
      _availableDayRecords.assignAll(days);
      await _loadDayStatuses(doctorId, clinicId, days);

      if (doctorAvailableDays.isEmpty) {
        AppAlerts.showError(
          title: AppMessages.errorTitle,
          message: 'No booking days are currently available for this clinic.',
        );
        return;
      }

      await selectDate(doctorAvailableDays.first, doctorId: doctorId);
    } catch (error) {
      _availableDayRecords.clear();
      AppAlerts.showError(
        title: AppMessages.errorTitle,
        message: _messageFromError(error),
      );
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> _loadDayStatuses(
    int doctorId,
    int clinicId,
    List<Map<String, dynamic>> days,
  ) async {
    dayStatuses.clear();
    final statuses = await Future.wait(
      days.map((record) async {
        final requestedDate = record['date']?.toString();
        if (requestedDate == null || requestedDate.isEmpty) {
          return const MapEntry('', 'unknown');
        }
        try {
          final status = await _repo.getAppointmentDayStatus(
            doctorId: doctorId,
            clinicId: clinicId,
            requestedDate: requestedDate,
          );
          return MapEntry(requestedDate, status);
        } catch (_) {
          return MapEntry(requestedDate, 'unknown');
        }
      }),
    );
    dayStatuses.addAll(
      Map.fromEntries(statuses.where((entry) => entry.key.isNotEmpty)),
    );
  }

  String dayStatusForDate(DateTime date) {
    return dayStatuses[DateFormat('yyyy-MM-dd').format(date)] ?? 'unknown';
  }

  bool isFullDate(DateTime date) => dayStatusForDate(date) == 'full';

  bool isAvailableDay(DateTime date) {
    final value = DateFormat('yyyy-MM-dd').format(date);
    return _availableDayRecords.any(
      (record) => record['date']?.toString() == value,
    );
  }

  Future<void> selectDate(DateTime date, {required int doctorId}) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    if (!isAvailableDay(normalizedDate)) {
      AppAlerts.showError(
        title: AppMessages.errorTitle,
        message: 'This day is not available for booking.',
      );
      return;
    }

    final clinicId = selectedClinicId.value;
    if (clinicId == null) {
      return;
    }

    selectedDate = normalizedDate;
    _clearWaitlistMembershipState();
    _clearScheduleAndSlotSelection();
    isLoading.value = true;
    try {
      final requestedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      final status = await _repo.getAppointmentDayStatus(
        doctorId: doctorId,
        clinicId: clinicId,
        requestedDate: requestedDate,
      );
      selectedDayStatus.value = status;
      dayStatuses[requestedDate] = status;

      if (status != 'available') {
        if (isSelectedDayFull) {
          await _loadWaitlistMembership(
            doctorId: doctorId,
            clinicId: clinicId,
            requestedDate: requestedDate,
          );
        }
        update();
        return;
      }

      final schedules = await _repo.getDoctorScheduleForPatient(
        doctorId,
        clinicId,
      );
      final selectedDayOfWeek = selectedDate.weekday % 7;
      final normalSchedules = schedules
          .where((item) {
            final dayOfWeek = _asInt(item['dayOfWeek']);
            final type = item['type']?.toString().toLowerCase();
            return dayOfWeek == selectedDayOfWeek && type == 'normal';
          })
          .map((item) => Map<String, dynamic>.from(item))
          .toList();

      selectedDateSchedules.assignAll(normalSchedules);
      for (final schedule in normalSchedules) {
        final label = _scheduleLabel(schedule);
        _schedulesByLabel[label] = schedule;
      }
      availablePeriodsForSelectedDay.assignAll(_schedulesByLabel.keys);
      await _loadScheduleAvailability(doctorId, clinicId, normalSchedules);

      if (normalSchedules.isEmpty) {
        selectedDayStatus.value = 'full';
        await _loadWaitlistMembership(
          doctorId: doctorId,
          clinicId: clinicId,
          requestedDate: requestedDate,
        );
      }
    } catch (error) {
      selectedDayStatus.value = '';
      AppAlerts.showError(
        title: AppMessages.errorTitle,
        message: _messageFromError(error),
      );
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> _loadScheduleAvailability(
    int doctorId,
    int clinicId,
    List<Map<String, dynamic>> schedules,
  ) async {
    final requestedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    final unavailablePeriods = await Future.wait(
      schedules.map((schedule) async {
        final label = _scheduleLabel(schedule);
        final scheduleId = _asInt(schedule['id']);
        if (scheduleId == 0) {
          return label;
        }
        try {
          final slot = await _repo.getNextAvailableTime(
            doctorId,
            clinicId,
            scheduleId,
            requestedDate,
            selectedType,
          );
          final startTime = slot['startTime']?.toString();
          final endTime = slot['endTime']?.toString();
          return startTime == null ||
                  endTime == null ||
                  startTime.isEmpty ||
                  endTime.isEmpty
              ? label
              : null;
        } catch (_) {
          return label;
        }
      }),
    );
    _unavailableSchedulePeriods
      ..clear()
      ..addAll(unavailablePeriods.whereType<String>());
  }

  Future<void> selectPeriod(String period, {required int doctorId}) async {
    final schedule = _schedulesByLabel[period];
    final clinicId = selectedClinicId.value;
    if (schedule == null ||
        clinicId == null ||
        isSelectedDayFull ||
        isScheduleUnavailable(period)) {
      return;
    }

    selectedPeriod = period;
    selectedScheduleId.value = _asInt(schedule['id']);
    availableTimeSlots.clear();
    selectedTimeSlot.value = null;
    await _loadAvailableAppointmentTime(doctorId, clinicId);
    update();
  }

  Future<void> selectType(String type, {required int doctorId}) async {
    if (!appointmentTypes.contains(type)) {
      return;
    }

    selectedType = type;
    _unavailableSchedulePeriods.clear();
    availableTimeSlots.clear();
    selectedTimeSlot.value = null;
    final clinicId = selectedClinicId.value;
    if (clinicId != null && selectedDateSchedules.isNotEmpty) {
      await _loadScheduleAvailability(
        doctorId,
        clinicId,
        selectedDateSchedules,
      );
    }
    if (selectedScheduleId.value != null && clinicId != null) {
      await _loadAvailableAppointmentTime(doctorId, clinicId);
    }
    update();
  }

  void selectTimeSlot(Map<String, String> slot) {
    selectedTimeSlot.value = slot;
    update();
  }

  bool isScheduleUnavailable(String period) =>
      _unavailableSchedulePeriods.contains(period);

  void selectReferral(dynamic referral) {
    selectedReferral.value = referral;
    update();
  }

  Future<void> _loadAvailableAppointmentTime(int doctorId, int clinicId) async {
    final scheduleId = selectedScheduleId.value;
    if (scheduleId == null) {
      return;
    }

    isLoading.value = true;
    try {
      final slot = await _repo.getNextAvailableTime(
        doctorId,
        clinicId,
        scheduleId,
        DateFormat('yyyy-MM-dd').format(selectedDate),
        selectedType,
      );
      final startTime = slot['startTime']?.toString();
      final endTime = slot['endTime']?.toString();
      if (startTime == null ||
          endTime == null ||
          startTime.isEmpty ||
          endTime.isEmpty) {
        throw const FormatException('Invalid available-time response.');
      }
      _unavailableSchedulePeriods.remove(selectedPeriod);
      availableTimeSlots.assignAll([
        {'startTime': startTime, 'endTime': endTime},
      ]);
    } catch (error) {
      _unavailableSchedulePeriods.add(selectedPeriod);
      availableTimeSlots.clear();
      selectedTimeSlot.value = null;
      AppAlerts.showError(
        title: AppMessages.errorTitle,
        message:
            'No appointment time is currently available for this schedule.',
      );
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> _loadWaitlistMembership({
    required int doctorId,
    required int clinicId,
    required String requestedDate,
  }) async {
    final request = ++_waitlistMembershipRequest;
    waitlistMembershipState.value = 'loading';
    try {
      final entries = await _repo.getMyWaitlists();
      if (!_isCurrentWaitlistTarget(
        request: request,
        doctorId: doctorId,
        clinicId: clinicId,
        requestedDate: requestedDate,
      )) {
        return;
      }

      final joined = entries.whereType<Map>().any((entry) {
        final value = Map<String, dynamic>.from(entry);
        return _asInt(value['doctorProfileId']) == doctorId &&
            _asInt(value['clinicId']) == clinicId &&
            _dateOnly(value['requestedDate']) == requestedDate;
      });
      waitlistMembershipState.value = joined ? 'joined' : 'not_joined';
    } catch (_) {
      if (_isCurrentWaitlistTarget(
        request: request,
        doctorId: doctorId,
        clinicId: clinicId,
        requestedDate: requestedDate,
      )) {
        waitlistMembershipState.value = 'error';
      }
    } finally {
      if (request == _waitlistMembershipRequest) {
        update();
      }
    }
  }

  bool _isCurrentWaitlistTarget({
    required int request,
    required int doctorId,
    required int clinicId,
    required String requestedDate,
  }) {
    return request == _waitlistMembershipRequest &&
        isSelectedDayFull &&
        selectedClinicId.value == clinicId &&
        DateFormat('yyyy-MM-dd').format(selectedDate) == requestedDate &&
        _loadedDoctorId == doctorId;
  }

  String _dateOnly(dynamic value) {
    return value?.toString().split('T').first ?? '';
  }

  void _clearWaitlistMembershipState() {
    _waitlistMembershipRequest++;
    waitlistMembershipState.value = 'idle';
  }

  Future<void> joinSelectedDayWaitlist(int doctorId) async {
    final clinicId = selectedClinicId.value;
    if (!canJoinWaitlist || clinicId == null) {
      return;
    }

    final requestedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    isLoading.value = true;
    try {
      final joined = await _repo.joinWaitlist(
        doctorId: doctorId,
        clinicId: clinicId,
        requestedDate: requestedDate,
      );
      if (joined) {
        if (isSelectedDayFull &&
            selectedClinicId.value == clinicId &&
            DateFormat('yyyy-MM-dd').format(selectedDate) == requestedDate) {
          waitlistMembershipState.value = 'joined';
          update();
        }
        AppAlerts.showSuccess(
          title: AppMessages.waitlistSuccessTitle,
          message: AppMessages.waitlistSuccessBody,
        );
      }
    } catch (error) {
      AppAlerts.showError(
        title: AppMessages.waitlistErrorTitle,
        message: _messageFromError(error),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitAppointment({
    required int doctorId,
    int? referralId,
  }) async {
    final clinicId = selectedClinicId.value;
    final slot = selectedTimeSlot.value;
    if (clinicId == null ||
        selectedScheduleId.value == null ||
        slot == null ||
        isSelectedDayFull) {
      AppAlerts.showError(
        title: AppMessages.errorTitle,
        message:
            'Select an available day, schedule, and appointment time first.',
      );
      return;
    }

    isLoading.value = true;
    try {
      final completion = await _repo.getCompletionStatus();
      if (!completion.completed) {
        _showIncompleteProfileWarning();
        return;
      }

      final appointment = CreateAppointmentModel(
        doctorId: doctorId,
        clinicId: clinicId,
        requestedDate: DateFormat('yyyy-MM-dd').format(selectedDate),
        startTime: slot['startTime']!,
        endTime: slot['endTime']!,
        type: selectedType,
        priority: '1',
        reasonForVisit: 'General checkup',
        referralId: referralId ?? _referralId(selectedReferral.value),
      );

      final success = await _repo.createAppointment(appointment);
      if (!success) {
        return;
      }

      final appointmentsController = Get.isRegistered<AppointmentsController>()
          ? Get.find<AppointmentsController>()
          : Get.put(AppointmentsController());
      await appointmentsController.fetchAppointments();
      appointmentsController.selectUpcomingTab();
      await playSuccessEffect();
      Get.find<NavigationController>().changeTab(1);
      Get.until((route) => route.settings.name == AppRoutes.home);
    } on DioException catch (error) {
      await _refreshAfterBookingConflict(doctorId, error);
    } catch (error) {
      AppAlerts.showError(
        title: AppMessages.errorTitle,
        message: _messageFromError(error),
      );
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> _refreshAfterBookingConflict(
    int doctorId,
    DioException error,
  ) async {
    final message = _dioMessage(error);
    final isSlotConflict =
        message.toLowerCase().contains('slot') ||
        message.toLowerCase().contains('overlap') ||
        message.toLowerCase().contains('already booked');

    AppAlerts.showError(
      title: AppMessages.errorTitle,
      message: isSlotConflict
          ? 'That appointment time is no longer available. Availability has been refreshed.'
          : message,
    );

    if (isSlotConflict) {
      await selectDate(selectedDate, doctorId: doctorId);
    }
  }

  void _clearBookingSelection() {
    selectedClinicId.value = null;
    dayStatuses.clear();
    _availableDayRecords.clear();
    _clearDateDependentSelection();
  }

  void _clearDateDependentSelection() {
    selectedDayStatus.value = '';
    _clearWaitlistMembershipState();
    _clearScheduleAndSlotSelection();
  }

  void _clearScheduleAndSlotSelection() {
    selectedDateSchedules.clear();
    _unavailableSchedulePeriods.clear();
    availablePeriodsForSelectedDay.clear();
    _schedulesByLabel.clear();
    selectedPeriod = '';
    selectedScheduleId.value = null;
    availableTimeSlots.clear();
    selectedTimeSlot.value = null;
  }

  int _asInt(dynamic value) => int.tryParse(value?.toString() ?? '') ?? 0;

  String _scheduleLabel(Map<String, dynamic> schedule) {
    final start = schedule['startTime']?.toString() ?? '';
    final end = schedule['endTime']?.toString() ?? '';
    return '$start - $end';
  }

  int? _referralId(dynamic referral) {
    if (referral is Map) {
      final value = referral['id'] ?? referral['referralId'];
      final parsed = _asInt(value);
      return parsed == 0 ? null : parsed;
    }
    final parsed = _asInt(referral);
    return parsed == 0 ? null : parsed;
  }

  String _dioMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map && data['message'] != null) {
      final message = data['message'];
      return message is List ? message.join('\n') : message.toString();
    }
    return error.message ?? AppMessages.unexpectedError;
  }

  String _messageFromError(Object error) {
    return error.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
  }

  void _showIncompleteProfileWarning() {
    Get.defaultDialog(
      title: '',
      titlePadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.redAccent,
            size: 54,
          ),
          const SizedBox(height: 12),
          const Text(
            AppMessages.incompleteProfileTitle,
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            AppMessages.incompleteProfileBody,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black87, fontSize: 14, height: 1.5),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      radius: 16,
      barrierDismissible: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      textCancel: AppMessages.skip,
      cancelTextColor: Colors.grey.shade700,
      onCancel: () {},
      textConfirm: AppMessages.completeProfile,
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      onConfirm: () {
        Get.back();
        Get.toNamed(AppRoutes.medicalProfile);
      },
    );
  }

  Future<void> checkProfileAndProceed(VoidCallback onCompleted) async {
    isLoading.value = true;
    try {
      final completion = await _repo.getCompletionStatus();
      if (!completion.completed) {
        _showIncompleteProfileWarning();
        return;
      }
      onCompleted();
    } catch (error) {
      if (_messageFromError(error).contains('Patient profile not found')) {
        _showIncompleteProfileWarning();
      } else {
        AppAlerts.showError(
          title: AppMessages.errorTitle,
          message: AppMessages.connectionError,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> playSuccessEffect() async {
    AppAlerts.showSuccess(
      title: AppMessages.successTitle,
      message: AppMessages.appointmentSuccess,
    );
    await _audioPlayer.play(AssetSource('sounds/notification_sound.mp3'));
  }
}
