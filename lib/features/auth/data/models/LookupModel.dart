class LookupModel {
  final int id;
  final String category;
  final String value;
  final String labelEn;
  final String labelAr;

  LookupModel({
    required this.id,
    required this.category,
    required this.value,
    required this.labelEn,
    required this.labelAr,
  });

  factory LookupModel.fromJson(Map<String, dynamic> json) {
    return LookupModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      category: json['category'] ?? '',
      value: json['value'] ?? '',
      labelEn: json['labelEn'] ?? '',
      labelAr: json['labelAr'] ?? '',
    );
  }
}
