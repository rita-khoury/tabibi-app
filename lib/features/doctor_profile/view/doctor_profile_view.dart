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
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
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

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),


            Expanded(
              flex: 4,
              child: _buildDoctorImage(doctor['image']),
            ),
            const SizedBox(height: 15),

            _buildDoctorHeader(
              doctor['name'],
              doctor['speciality'],
              doctor['rating'],
            ),
            const SizedBox(height: 15),

            _buildStatsRow(),
            const SizedBox(height: 15),


            Expanded(
              flex: 2,
              child: _buildAboutSection(),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 25, top: 10),
              child: _buildBookButton(),
            ),
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
          elevation: 0,
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
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildDoctorImage(String imageUrl) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 18),
              const SizedBox(width: 4),
              Text(
                "$rating",
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatItem('116+', 'Patients', Icons.people_alt_outlined),
        _buildStatItem('3+', 'Years exp', Icons.workspace_premium_outlined),
        _buildStatItem('4.9', 'Rating', Icons.star_border_rounded),
        _buildStatItem('90+', 'Reviews', Icons.chat_bubble_outline_rounded),
      ],
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.lightGray.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: AppColors.primaryBlue,
              size: 22,
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.gray,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About Me',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: Text(
            'Experienced doctor dedicated to providing high-quality healthcare services with modern medical practices.',
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            style: const TextStyle(
              color: AppColors.gray,
              height: 1.4,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}