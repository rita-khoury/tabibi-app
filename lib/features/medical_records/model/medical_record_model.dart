class MedicalProfileLookupOption {
  final int? id;
  final String value;
  final String labelEn;
  final String labelAr;

  const MedicalProfileLookupOption({
    this.id,
    required this.value,
    required this.labelEn,
    required this.labelAr,
  });

  factory MedicalProfileLookupOption.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    return MedicalProfileLookupOption(
      id: rawId is int ? rawId : int.tryParse(rawId?.toString() ?? ''),
      value: json['value']?.toString() ?? '',
      labelEn: json['labelEn']?.toString() ?? '',
      labelAr: json['labelAr']?.toString() ?? '',
    );
  }

  String get displayLabel {
    if (labelEn.trim().isNotEmpty) return labelEn;
    if (labelAr.trim().isNotEmpty) return labelAr;
    return value;
  }
}

class MedicalProfileModel {
  final int? id;
  final int? patientProfileId;
  final String? bloodType;
  final String? pregnancyStatus;
  final String? disabilityInfo;
  final String? currentSymptoms;
  final List<String>? allergies;
  final List<String>? chronicConditions;
  final List<String>? pastSurgeries;
  final List<String>? familyHistory;
  final List<String>? currentMedications;
  final List<String>? lifestyleHabits;
  final List<String>? vaccinationStatus;

  const MedicalProfileModel({
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
      id: _asInt(json['id']),
      patientProfileId: _asInt(
        json['patientProfileId'] ?? json['patient_profile_id'],
      ),
      bloodType: _asNullableString(json['bloodType'] ?? json['blood_type']),
      pregnancyStatus: _asNullableString(
        json['pregnancyStatus'] ?? json['pregnancy_status'],
      ),
      disabilityInfo: _asNullableString(
        json['disabilityInfo'] ?? json['disability_info'],
      ),
      currentSymptoms: _asNullableString(
        json['currentSymptoms'] ?? json['current_symptoms'],
      ),
      allergies: _asNullableStringList(json['allergies']),
      chronicConditions: _asNullableStringList(
        json['chronicConditions'] ?? json['chronic_conditions'],
      ),
      pastSurgeries: _asNullableStringList(
        json['pastSurgeries'] ?? json['past_surgeries'],
      ),
      familyHistory: _asNullableStringList(
        json['familyHistory'] ?? json['family_history'],
      ),
      currentMedications: _asNullableStringList(
        json['currentMedications'] ?? json['current_medications'],
      ),
      lifestyleHabits: _asNullableStringList(
        json['lifestyleHabits'] ?? json['lifestyle_habits'],
      ),
      vaccinationStatus: _asNullableStringList(
        json['vaccinationStatus'] ?? json['vaccination_status'],
      ),
    );
  }

  Map<String, dynamic> toDto() {
    return {
      'bloodType': _emptyToNull(bloodType),
      'pregnancyStatus': _emptyToNull(pregnancyStatus),
      'disabilityInfo': _emptyToNull(disabilityInfo),
      'currentSymptoms': currentSymptoms,
      'allergies': allergies ?? <String>[],
      'chronicConditions': chronicConditions ?? <String>[],
      'pastSurgeries': pastSurgeries ?? <String>[],
      'familyHistory': familyHistory ?? <String>[],
      'currentMedications': currentMedications ?? <String>[],
      'lifestyleHabits': lifestyleHabits ?? <String>[],
      'vaccinationStatus': vaccinationStatus ?? <String>[],
    };
  }

  static int? _asInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }

  static String? _asNullableString(dynamic value) {
    if (value == null) return null;
    return value.toString().trim();
  }

  static List<String>? _asNullableStringList(dynamic value) {
    if (value == null) return null;
    if (value is List) {
      return value
          .map((item) => item.toString().trim())
          .where((item) => item.isNotEmpty)
          .toList();
    }
    final item = value.toString().trim();
    return item.isEmpty ? <String>[] : <String>[item];
  }

  static String? _emptyToNull(String? value) {
    final result = value?.trim();
    return result == null || result.isEmpty ? null : result;
  }
}
