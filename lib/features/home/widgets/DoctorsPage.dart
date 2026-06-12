import 'package:flutter/material.dart';
import '../widgets/doctor_card.dart';
import 'package:tabibi/core/constance/app_colors.dart';

class DoctorsPage extends StatelessWidget {
  final String speciality;
  final List<Map> doctors;

  const DoctorsPage({
    super.key,
    required this.speciality,
    required this.doctors,
  });

  @override
  Widget build(BuildContext context) {
    final filteredDoctors = doctors
        .where((doc) => doc["speciality"] == speciality)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.lightGray,

      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: AppColors.lightGray,
        elevation: 0,

        iconTheme: const IconThemeData(
          color: Colors.black,
        ),

        title: Text(
          speciality,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView.builder(
          itemCount: filteredDoctors.length,
          itemBuilder: (context, index) {
            return DoctorCard(doc: filteredDoctors[index]);
          },
        ),
      ),
    );
  }
}