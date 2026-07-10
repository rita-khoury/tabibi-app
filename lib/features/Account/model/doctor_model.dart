class DoctorModel {
  final int id;
  final String name;

  DoctorModel({required this.id, required this.name});

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'],
      name: json['name'],
    );
  }
}