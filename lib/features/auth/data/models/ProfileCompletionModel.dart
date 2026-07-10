// class ProfileCompletionModel {
//   final bool completed;
//   final int completionPercentage;
//   final List<String> missingFields;
//
//   ProfileCompletionModel({
//     required this.completed,
//     required this.completionPercentage,
//     required this.missingFields,
//   });
//
//   factory ProfileCompletionModel.fromJson(Map<String, dynamic> json) {
//     return ProfileCompletionModel(
//       completed: json['completed'] ?? false,
//       completionPercentage: json['completionPercentage'] ?? 0,
//       missingFields: List<String>.from(json['missingFields'] ?? []),
//     );
//   }
// }
// class CompleteProfileRequest {
//   final String bloodType;
//   final String disabilityInfo;
//   final String currentSymptoms;
//   final List<String> allergies;
//   final List<String> chronicConditions;
//   final List<String> pastSurgeries;
//   final List<String> familyHistory;
//   final List<String> currentMedications;
//   final List<String> lifestyleHabits;
//   final List<String> vaccinationStatus;
//   final String pregnancyStatus;
//
//   CompleteProfileRequest({
//     required this.bloodType,
//     required this.disabilityInfo,
//     required this.currentSymptoms,
//     required this.allergies,
//     required this.chronicConditions,
//     required this.pastSurgeries,
//     required this.familyHistory,
//     required this.currentMedications,
//     required this.lifestyleHabits,
//     required this.vaccinationStatus,
//     required this.pregnancyStatus,
//   });
//
//   Map<String, dynamic> toJson() {
//     return {
//       "bloodType": bloodType,
//       "disabilityInfo": disabilityInfo,
//       "currentSymptoms": currentSymptoms,
//       "allergies": allergies,
//       "chronicConditions": chronicConditions,
//       "pastSurgeries": pastSurgeries,
//       "familyHistory": familyHistory,
//       "currentMedications": currentMedications,
//       "lifestyleHabits": lifestyleHabits,
//       "vaccinationStatus": vaccinationStatus,
//       "pregnancyStatus": pregnancyStatus,
//     };
//   }
// }
class ProfileCompletionModel {
  final bool completed;
  final int completionPercentage;
  final List<String> missingFields;

  ProfileCompletionModel({
    required this.completed,
    required this.completionPercentage,
    required this.missingFields,
  });

  factory ProfileCompletionModel.fromJson(Map<String, dynamic> json) {
    return ProfileCompletionModel(
      completed: json['completed'] ?? false,
      completionPercentage: json['completionPercentage'] ?? 0,
      missingFields: List<String>.from(json['missingFields'] ?? []),
    );
  }
}

class CompleteProfileRequest {
  final String bloodType;
  final String disabilityInfo;
  final String currentSymptoms;
  final List<String> allergies;
  final List<String> chronicConditions;
  final List<String> pastSurgeries;
  final List<String> familyHistory;
  final List<String> currentMedications;
  final List<String> lifestyleHabits;
  final List<String> vaccinationStatus;
  final String pregnancyStatus;

  CompleteProfileRequest({
    required this.bloodType,
    required this.disabilityInfo,
    required this.currentSymptoms,
    required this.allergies,
    required this.chronicConditions,
    required this.pastSurgeries,
    required this.familyHistory,
    required this.currentMedications,
    required this.lifestyleHabits,
    required this.vaccinationStatus,
    required this.pregnancyStatus,
  });

  factory CompleteProfileRequest.fromJson(Map<String, dynamic> json) {
    return CompleteProfileRequest(
      bloodType: json['bloodType'] ?? 'O+',
      disabilityInfo: json['disabilityInfo'] ?? '',
      currentSymptoms: json['currentSymptoms'] ?? '',
      allergies: List<String>.from(json['allergies'] ?? []),
      chronicConditions: List<String>.from(json['chronicConditions'] ?? []),
      pastSurgeries: List<String>.from(json['pastSurgeries'] ?? []),
      familyHistory: List<String>.from(json['familyHistory'] ?? []),
      currentMedications: List<String>.from(json['currentMedications'] ?? []),
      lifestyleHabits: List<String>.from(json['lifestyleHabits'] ?? []),
      vaccinationStatus: List<String>.from(json['vaccinationStatus'] ?? []),
      pregnancyStatus: json['pregnancyStatus'] ?? 'NOT_PREGNANT',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "bloodType": bloodType,
      "disabilityInfo": disabilityInfo,
      "currentSymptoms": currentSymptoms,
      "allergies": allergies,
      "chronicConditions": chronicConditions,
      "pastSurgeries": pastSurgeries,
      "familyHistory": familyHistory,
      "currentMedications": currentMedications,
      "lifestyleHabits": lifestyleHabits,
      "vaccinationStatus": vaccinationStatus,
      "pregnancyStatus": pregnancyStatus,
    };
  }
}
