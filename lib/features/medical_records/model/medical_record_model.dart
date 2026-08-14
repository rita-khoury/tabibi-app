// class MedicalProfileModel {
//   final int? id;
//   final String? bloodType;
//   final String? allergies;
//   final String? chronicDiseases;
//   final String? surgeries;
//
//   MedicalProfileModel({
//     this.id,
//     this.bloodType,
//     this.allergies,
//     this.chronicDiseases,
//     this.surgeries,
//   });
//
//   factory MedicalProfileModel.fromJson(Map<String, dynamic> json) {
//     return MedicalProfileModel(
//       id: json['id'],
//       bloodType: json['bloodType'],
//       allergies: json['allergies'],
//       chronicDiseases: json['chronicDiseases'],
//       surgeries: json['surgeries'],
//     );
//   }
// }
//
// class MedicalHistoryModel {
//   final int id;
//   final String diagnosis;
//   final String treatment;
//   final String notes;
//   final String createdAt;
//
//   MedicalHistoryModel({
//     required this.id,
//     required this.diagnosis,
//     required this.treatment,
//     required this.notes,
//     required this.createdAt,
//   });
//
//   factory MedicalHistoryModel.fromJson(Map<String, dynamic> json) {
//     return MedicalHistoryModel(
//       id: json['id'],
//       diagnosis: json['diagnosis'] ?? "",
//       treatment: json['treatment'] ?? "",
//       notes: json['notes'] ?? "",
//       createdAt: json['createdAt'] ?? "",
//     );
//   }
// }
//
// class MedicalAttachmentModel {
//   final int id;
//   final String fileUrl;
//   final String? fileType;
//
//   MedicalAttachmentModel({
//     required this.id,
//     required this.fileUrl,
//     this.fileType,
//   });
//
//   factory MedicalAttachmentModel.fromJson(Map<String, dynamic> json) {
//     return MedicalAttachmentModel(
//       id: json['id'],
//       fileUrl: json['fileUrl'] ?? "",
//       fileType: json['fileType'],
//     );
//   }
// }


class MedicalProfileModel {
  final int? id;
  final int? patientProfileId;
  final String? bloodType;
  final String? pregnancyStatus;
  final String? disabilityInfo;
  final String? currentSymptoms;
  final List<dynamic>? allergies;
  final List<dynamic>? chronicConditions;
  final List<dynamic>? pastSurgeries;
  final String? familyHistory;
  final String? currentMedications;
  final String? lifestyleHabits;
  final String? vaccinationStatus;

  MedicalProfileModel({
    this.id,
    this.patientProfileId,
    this.bloodType,
    this.pregnancyStatus,
    this.disabilityInfo,
    this.currentSymptoms,
    this.allergies,
    this.chronicConditions,
    this.pastSurgeries,
    this.familyHistory,
    this.currentMedications,
    this.lifestyleHabits,
    this.vaccinationStatus,
  });

  factory MedicalProfileModel.fromJson(Map<String, dynamic> json) {
    return MedicalProfileModel(
      id: json['id'],
      patientProfileId: json['patientProfileId'] ?? json['patient_profile_id'],
      bloodType: json['bloodType'] ?? json['blood_type'],
      pregnancyStatus: json['pregnancyStatus'] ?? json['pregnancy_status'],
      disabilityInfo: json['disabilityInfo'] ?? json['disability_info'],
      currentSymptoms: json['currentSymptoms'] ?? json['current_symptoms'],
      allergies: json['allergies'] ?? [],
      chronicConditions: json['chronicConditions'] ?? json['chronic_conditions'] ?? [],
      pastSurgeries: json['pastSurgeries'] ?? json['past_surgeries'] ?? [],
      familyHistory: json['familyHistory'] ?? json['family_history'],
      currentMedications: json['currentMedications'] ?? json['current_medications'],
      lifestyleHabits: json['lifestyleHabits'] ?? json['lifestyle_habits'],
      vaccinationStatus: json['vaccinationStatus'] ?? json['vaccination_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (patientProfileId != null) 'patientProfileId': patientProfileId,
      'bloodType': bloodType,
      'pregnancyStatus': pregnancyStatus,
      'disabilityInfo': disabilityInfo,
      'currentSymptoms': currentSymptoms,
      'allergies': allergies,
      'chronicConditions': chronicConditions,
      'pastSurgeries': pastSurgeries,
      'familyHistory': familyHistory,
      'currentMedications': currentMedications,
      'lifestyleHabits': lifestyleHabits,
      'vaccinationStatus': vaccinationStatus,
    };
  }
}