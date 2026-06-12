import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import '../../appointment/view/appointment_view.dart';
import '../../appointment/controller/appointment_controller.dart';

class DoctorProfileView extends StatelessWidget {
  DoctorProfileView({super.key});

  final Map doctor = Get.arguments as Map;
  @override
  Widget build(BuildContext context) {
    final doctor = Get.arguments as Map;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Doctor',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),


            _buildDoctorImage(doctor['image']),
            const SizedBox(height: 20),


            _buildDoctorHeader(
              doctor['name'],
              doctor['speciality'],
              doctor['rating'],
            ),

            const SizedBox(height: 24),


            _buildStatsRow(),

            const SizedBox(height: 24),


            _buildAboutSection(),

            const SizedBox(height: 32),


            _buildBookButton(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }


  Widget _buildBookButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        onPressed: () {
          Get.put(AppointmentController());

          Get.to(
                () => const AppointmentView(),
            arguments: doctor,
          );
        },
        child: const Text(
          'Book Appointment',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }


  Widget _buildDoctorImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Image.network(
        imageUrl,
        height: 250,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }


  Widget _buildDoctorHeader(String name, String spec, dynamic rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              spec,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.gray,
              ),
            ),
          ],
        ),

        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber),
            Text(" $rating"),
          ],
        )
      ],
    );
  }


  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatItem('116+', 'Patients'),
        _buildStatItem('3+', 'Years'),
        _buildStatItem('4.9', 'Rating'),
        _buildStatItem('90+', 'Reviews'),
      ],
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: AppColors.lightGray,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person,
            color: AppColors.primaryBlue,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.gray,
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About Me',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Experienced doctor dedicated to providing high-quality healthcare services with modern medical practices.',
          style: TextStyle(color: AppColors.gray),
        ),
      ],
    );
  }
}