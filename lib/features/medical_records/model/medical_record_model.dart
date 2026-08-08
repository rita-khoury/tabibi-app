class MedicalProfileModel {
  final int? id;
  final String? bloodType;
  final String? allergies;
  final String? chronicDiseases;
  final String? surgeries;

  MedicalProfileModel({
    this.id,
    this.bloodType,
    this.allergies,
    this.chronicDiseases,
    this.surgeries,
  });

  factory MedicalProfileModel.fromJson(Map<String, dynamic> json) {
    return MedicalProfileModel(
      id: json['id'],
      bloodType: json['bloodType'],
      allergies: json['allergies'],
      chronicDiseases: json['chronicDiseases'],
      surgeries: json['surgeries'],
    );
  }
}

class MedicalHistoryModel {
  final int id;
  final String diagnosis;
  final String treatment;
  final String notes;
  final String createdAt;

  MedicalHistoryModel({
    required this.id,
    required this.diagnosis,
    required this.treatment,
    required this.notes,
    required this.createdAt,
  });

  factory MedicalHistoryModel.fromJson(Map<String, dynamic> json) {
    return MedicalHistoryModel(
      id: json['id'],
      diagnosis: json['diagnosis'] ?? "",
      treatment: json['treatment'] ?? "",
      notes: json['notes'] ?? "",
      createdAt: json['createdAt'] ?? "",
    );
  }
}

class MedicalAttachmentModel {
  final int id;
  final String fileUrl;
  final String? fileType;

  MedicalAttachmentModel({
    required this.id,
    required this.fileUrl,
    this.fileType,
  });

  factory MedicalAttachmentModel.fromJson(Map<String, dynamic> json) {
    return MedicalAttachmentModel(
      id: json['id'],
      fileUrl: json['fileUrl'] ?? "",
      fileType: json['fileType'],
    );
  }
}
