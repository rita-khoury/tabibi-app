// import 'package:audioplayers/audioplayers.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:intl/intl.dart';
// import 'package:tabibi/core/constance/app_colors.dart';
// import 'package:tabibi/features/auth/data/models/CreateAppointmentModel.dart';
// import 'package:tabibi/features/auth/repository/auth_repository.dart';
//
// import '../../../core/routes/app_routes.dart';
// import '../../appointments/controller/appointments_controller.dart';
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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import 'package:tabibi/features/auth/data/models/CreateAppointmentModel.dart';
import 'package:tabibi/features/auth/repository/auth_repository.dart';

import '../../../core/constance/app_messages.dart';
import '../../../core/constance/app_alerts.dart'; // استيراد ملف المساعدات والتنبيهات الموحدة
import '../../../core/routes/app_routes.dart';
import '../../appointments/controller/appointments_controller.dart';

class AppointmentController extends GetxController {
  final AuthRepository _repo = Get.find<AuthRepository>();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final GetStorage _box = GetStorage();

  RxBool isLoading = false.obs;
  var dontShowAgain = false.obs;
  Rxn<dynamic> selectedReferral = Rxn<dynamic>();

  DateTime selectedDate = DateTime.now();
  String selectedPeriod = "";
  String selectedType = "Initial Visit";
  var availableClinics = <dynamic>[].obs;
  var selectedClinicId = RxnInt();

  var doctorWorkDays = <String>[].obs;
  var doctorScheduleMap = <String, List<String>>{}.obs;
  final Map<String, Map<String, String>> _periodStartTimeMap = {};
  var availablePeriodsForSelectedDay = <String>[].obs;

  final List<String> appointmentTypes = [
    "Advice",
    "Follow-up",
    "NORMAL",
    "Initial Visit",
  ];

  List<DateTime> get nextDays =>
      List.generate(7, (i) => DateTime.now().add(Duration(days: i)));

  @override
  void onInit() {
    super.onInit();
    bool savedPreference = _box.read('hideTerms') ?? false;
    dontShowAgain.value = savedPreference;
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }

  void saveTermsPreference() {
    _box.write('hideTerms', dontShowAgain.value);
  }

  List<DateTime> get doctorAvailableDays {
    List<DateTime> validDays = [];
    DateTime today = DateTime.now();
    for (int i = 0; i < 14; i++) {
      DateTime day = today.add(Duration(days: i));
      String dayName = DateFormat('EEEE').format(day);
      if (doctorWorkDays.contains(dayName)) {
        validDays.add(day);
      }
    }
    return validDays;
  }

  void selectDate(DateTime date) {
    selectedDate = DateTime(date.year, date.month, date.day);
    String dayName = DateFormat('EEEE').format(selectedDate);

    if (doctorScheduleMap.containsKey(dayName)) {
      List<String> periods = doctorScheduleMap[dayName]!;
      availablePeriodsForSelectedDay.assignAll(periods);

      if (!periods.contains(selectedPeriod)) {
        selectedPeriod = periods.isNotEmpty ? periods.first : "";
      }
    } else {
      availablePeriodsForSelectedDay.clear();
      selectedPeriod = "";
    }

    update();
  }

  void selectPeriod(String period) {
    if (availablePeriodsForSelectedDay.contains(period)) {
      selectedPeriod = period;
      update();
    }
  }

  void selectType(String type) {
    selectedType = type;
    update();
  }

  void selectReferral(dynamic referral) {
    selectedReferral.value = referral;
    update();
  }

  String _getStartTime() {
    String dayName = DateFormat('EEEE').format(selectedDate);

    if (_periodStartTimeMap.containsKey(dayName) &&
        _periodStartTimeMap[dayName]!.containsKey(selectedPeriod)) {
      return _periodStartTimeMap[dayName]![selectedPeriod]!;
    }

    switch (selectedPeriod) {
      case "Morning":
        return "10:00:00";
      case "Afternoon":
        return "13:00:00";
      case "Evening":
        return "15:00:00";
      default:
        return "10:00:00";
    }
  }

  String _getEndTime() {
    try {
      DateTime start = DateFormat("HH:mm:ss").parse(_getStartTime());
      int duration = (selectedType == "Initial Visit") ? 30 : 20;
      return DateFormat(
        "HH:mm:ss",
      ).format(start.add(Duration(minutes: duration)));
    } catch (e) {
      return "10:30:00";
    }
  }

  Future<void> fetchClinics(int doctorId) async {
    isLoading.value = true;
    try {
      var clinics = await _repo.getClinicsForDoctor(doctorId);
      availableClinics.assignAll(clinics);

      if (clinics.isNotEmpty) {
        selectedClinicId.value = clinics.first.id;

        int currentClinicId = selectedClinicId.value!;
        var scheduleList = await _repo.getDoctorScheduleForPatient(
          doctorId,
          currentClinicId,
        );

        Map<String, List<String>> tempScheduleMap = {};
        _periodStartTimeMap.clear();

        final Map<int, String> dayOfWeekMap = {
          0: "Sunday",
          1: "Monday",
          2: "Tuesday",
          3: "Wednesday",
          4: "Thursday",
          5: "Friday",
          6: "Saturday",
        };

        for (var item in scheduleList) {
          var dayVal = item['dayOfWeek'] ?? item['day'];
          int? dayIndex = dayVal is int
              ? dayVal
              : int.tryParse(dayVal?.toString() ?? '');

          if (dayIndex != null && dayOfWeekMap.containsKey(dayIndex)) {
            String dayName = dayOfWeekMap[dayIndex]!;
            String startTime = item['startTime']?.toString() ?? "09:00:00";
            String endTime = item['endTime']?.toString() ?? "17:00:00";

            List<String> periods = [];

            if (item['periods'] is List) {
              periods = (item['periods'] as List)
                  .map((p) => p.toString())
                  .toList();
            } else if (item['period'] != null || item['shiftName'] != null) {
              periods.add(item['period'] ?? item['shiftName']);
            } else {
              int? startHour = int.tryParse(startTime.split(':').first);
              int? endHour = int.tryParse(endTime.split(':').first);

              if (startHour != null && endHour != null) {
                if (startHour < 12) {
                  periods.add("Morning");
                  _periodStartTimeMap.putIfAbsent(
                    dayName,
                        () => {},
                  )["Morning"] = startTime;
                }
                if ((startHour < 17 && endHour > 12) ||
                    (startHour >= 12 && startHour < 17)) {
                  periods.add("Afternoon");
                  String afternoonStart = (startHour >= 12 && startHour < 17)
                      ? startTime
                      : "13:00:00";
                  _periodStartTimeMap.putIfAbsent(
                    dayName,
                        () => {},
                  )["Afternoon"] = afternoonStart;
                }
                if (endHour >= 17 || startHour >= 17) {
                  periods.add("Evening");
                  String eveningStart = (startHour >= 17)
                      ? startTime
                      : "15:00:00";
                  _periodStartTimeMap.putIfAbsent(
                    dayName,
                        () => {},
                  )["Evening"] = eveningStart;
                }
              }

              if (periods.isEmpty) {
                periods.add("Morning");
                _periodStartTimeMap.putIfAbsent(dayName, () => {})["Morning"] =
                    startTime;
              }
            }

            if (tempScheduleMap.containsKey(dayName)) {
              for (var p in periods) {
                if (!tempScheduleMap[dayName]!.contains(p)) {
                  tempScheduleMap[dayName]!.add(p);
                }
              }
            } else {
              tempScheduleMap[dayName] = periods;
            }
          }
        }

        doctorScheduleMap.value = tempScheduleMap;
        doctorWorkDays.assignAll(doctorScheduleMap.keys.toList());

        List<DateTime> availableDays = doctorAvailableDays;
        if (availableDays.isNotEmpty) {
          selectDate(availableDays.first);
        } else {
          availablePeriodsForSelectedDay.clear();
        }
      }
    } catch (e) {
      debugPrint("Error fetching clinics and schedule: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitAppointment({
    required int doctorId,
    required int clinicId,
    int? referralId,
  }) async {
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
        requestedDate: DateFormat("yyyy-MM-dd").format(selectedDate),
        startTime: _getStartTime(),
        endTime: _getEndTime(),
        type: selectedType,
        priority: "1",
        reasonForVisit: "General checkup",
        referralId: referralId,
      );

      final success = await _repo.createAppointment(appointment);

      if (success) {
        if (Get.isRegistered<AppointmentsController>()) {
          Get.find<AppointmentsController>().fetchAppointments();
        }

        await playSuccessEffect();
        Get.back();
      }
    } on DioException catch (e) {
      String errorMessage = e.response?.data['message'] ?? "";
      int? statusCode = e.response?.statusCode;

      if (errorMessage.contains("Patient profile not found") ||
          statusCode == 404) {
        _showIncompleteProfileWarning();
        return;
      }

      if (statusCode == 400) {
        bool isDayFull =
            errorMessage.contains("full") ||
                errorMessage.contains("fully booked") ||
                errorMessage.contains("capacity") ||
                errorMessage.contains("overlaps");

        if (isDayFull) {
          Get.defaultDialog(
            title: AppMessages.dayFullyBookedTitle,
            middleText: AppMessages.dayFullyBookedBody,
            textConfirm: AppMessages.confirmYes,
            textCancel: AppMessages.cancel,
            confirmTextColor: Colors.white,
            buttonColor: const Color(0xFF007BFF),
            onConfirm: () async {
              Get.back();
              try {
                String formattedDate = DateFormat(
                  "yyyy-MM-dd",
                ).format(selectedDate);
                bool waitlistSuccess = await _repo.joinWaitlist(
                  doctorId: doctorId,
                  clinicId: clinicId,
                  requestedDate: formattedDate,
                );

                if (waitlistSuccess) {
                  if (Get.isRegistered<AppointmentsController>()) {
                    try {
                      await Get.find<AppointmentsController>().fetchWaitlist();
                    } catch (_) {}
                  }

                  // استخدام AppAlerts للنجاح
                  AppAlerts.showSuccess(
                    title: AppMessages.waitlistSuccessTitle,
                    message: AppMessages.waitlistSuccessBody,
                  );
                }
              } on DioException catch (waitlistError) {
                var responseData = waitlistError.response?.data;
                String waitlistMsg = "";

                if (responseData is Map && responseData.containsKey('message')) {
                  waitlistMsg = responseData['message'].toString();
                } else if (responseData is String) {
                  waitlistMsg = responseData;
                } else {
                  waitlistMsg = waitlistError.message ?? AppMessages.defaultWaitlistError;
                }

                String cleanMessage = waitlistMsg.replaceFirst(
                    RegExp(r'^Exception:\s*'), '');

                // استخدام AppAlerts للخطأ
                AppAlerts.showError(
                  title: AppMessages.waitlistErrorTitle,
                  message: cleanMessage,
                );
              } catch (e) {
                String realError = e.toString().replaceFirst(
                    RegExp(r'^Exception:\s*'), '');
                // استخدام AppAlerts للخطأ
                AppAlerts.showError(
                  title: AppMessages.errorTitle,
                  message: realError,
                );
              }
            },
          );
        } else {
          // استخدام AppAlerts للتنبيه/الملاحظة
          AppAlerts.showNotice(
            title: AppMessages.noticeTitle,
            message: errorMessage.isNotEmpty
                ? errorMessage
                : AppMessages.defaultBookingError,
          );
        }
      } else {
        // استخدام AppAlerts للخطأ
        AppAlerts.showError(
          title: AppMessages.errorTitle,
          message: errorMessage.isNotEmpty ? errorMessage : AppMessages.connectionError,
        );
      }
    } catch (e) {
      if (e.toString().contains("Patient profile not found")) {
        _showIncompleteProfileWarning();
        return;
      }

      debugPrint("Detailed unexpected error: $e");
      // استخدام AppAlerts للخطأ
      AppAlerts.showError(
        title: AppMessages.errorTitle,
        message: AppMessages.unexpectedError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _showIncompleteProfileWarning() {
    Get.defaultDialog(
      title: "",
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
    } on DioException catch (e) {
      if (e.response?.statusCode == 404 ||
          (e.response?.data['message']?.toString().contains(
            "Patient profile not found",
          ) ??
              false)) {
        _showIncompleteProfileWarning();
      } else {
        // استخدام AppAlerts للخطأ
        AppAlerts.showError(
          title: AppMessages.errorTitle,
          message: AppMessages.connectionError,
        );
      }
    } catch (e) {
      if (e.toString().contains("Patient profile not found")) {
        _showIncompleteProfileWarning();
      } else {
        // استخدام AppAlerts للخطأ
        AppAlerts.showError(
          title: AppMessages.errorTitle,
          message: AppMessages.unexpectedError,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> playSuccessEffect() async {
    // استخدام AppAlerts للنجاح
    AppAlerts.showSuccess(
      title: AppMessages.successTitle,
      message: AppMessages.appointmentSuccess,
    );
    await _audioPlayer.play(AssetSource("sounds/notification_sound.mp3"));
  }
}