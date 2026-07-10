import 'package:flutter/material.dart';
import '../widgets/doctor_card.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import '../../../features/auth/data/models/DoctorModel.dart';

class DoctorsPage extends StatelessWidget {
  final String speciality;
  final List<DoctorModel> filteredDoctors;

  DoctorsPage({
    super.key,
    required this.speciality,
    required List<DoctorModel> doctors,
  }) : filteredDoctors = doctors
           .where(
             (doc) =>
                 doc.specialization.toLowerCase() == speciality.toLowerCase(),
           )
           .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: AppColors.lightGray,
        elevation: 0,
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
        child: filteredDoctors.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search_off, size: 60, color: Colors.grey),
                    const SizedBox(height: 10),
                    Text("No doctors found for $speciality"),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: filteredDoctors.length,
                itemBuilder: (context, index) {
                  return DoctorCard(doc: filteredDoctors[index]);
                },
              ),
      ),
    );
  }
}
