import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import '../../appointment/view/appointment_view.dart';
import '../binding/doctor_ratings_binding.dart';
import '../controller/doctor_profile_controller.dart';
import '../../../features/auth/data/models/DoctorModel.dart';
import 'doctor_ratings_view.dart';

class DoctorProfileView extends StatelessWidget {
  final controller = Get.put(DoctorProfileController());

  DoctorProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryBlue),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Doctor Profile',
          style: TextStyle(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value || controller.doctor.value == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final doc = controller.doctor.value!;
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              _buildImageStack(doc.image),
              const SizedBox(height: 20),
              _buildHeader(doc),
              const SizedBox(height: 20),
              _buildStatsRow(doc),
              const SizedBox(height: 20),
              _buildInfoRow(doc),
              const SizedBox(height: 20),
              _buildAbout(doc),
              const SizedBox(height: 30),
              _buildBookButton(doc),
              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildImageStack(String url) => Stack(
    children: [
      Container(
        height: 250,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
        ),
      ),
      Positioned(
        top: 15,
        left: 15,
        child: Obx(
          () => Material(
            color: Colors.transparent,
            child: IconButton(
              onPressed: controller.isFavoriteLoading.value
                  ? null
                  : () => controller.toggleFavorite(),
              icon: Icon(
                controller.doctor.value?.isFavorite == true
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: controller.doctor.value?.isFavorite == true
                    ? Colors.red
                    : Colors.white,
                shadows: const [Shadow(color: Colors.black54, blurRadius: 4)],
              ),
              iconSize: 32,
            ),
          ),
        ),
      ),
    ],
  );

  Widget _buildHeader(DoctorModel doc) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                doc.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (doc.isApproved) const SizedBox(width: 5),
              if (doc.isApproved)
                const Icon(Icons.verified, color: Colors.blue, size: 18),
            ],
          ),
          Text(
            doc.specialization,
            style: const TextStyle(color: AppColors.gray),
          ),
        ],
      ),
      InkWell(
        onTap: () {
          Get.to(
            () => const DoctorRatingsView(),
            binding: DoctorRatingsBinding(),
            arguments: doc.id,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 18),
              const SizedBox(width: 4),
              Text(
                doc.averageRating.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: Colors.amber,
              ),
            ],
          ),
        ),
      ),
    ],
  );

  Widget _buildStatsRow(DoctorModel doc) => Row(
    children: [
      _statItem('Exp', '${doc.experienceYears}y'),
      _statItem('Clinics', doc.clinic != null ? '1' : '0'),
      _statItem('Fee', '\$${doc.initialVisitFee ?? '0'}'),
    ],
  );

  Widget _statItem(String title, String val) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: AppColors.lightGray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(val, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(
            title,
            style: const TextStyle(fontSize: 10, color: AppColors.gray),
          ),
        ],
      ),
    ),
  );

  Widget _buildInfoRow(DoctorModel doc) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColors.lightGray.withOpacity(0.3),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Text(
      "Languages: ${doc.languagesSpoken.isEmpty ? 'N/A' : doc.languagesSpoken.join(', ')}",
    ),
  );

  Widget _buildAbout(DoctorModel doc) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'About Me',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      const SizedBox(height: 8),
      Text(
        doc.bio ?? 'No info available',
        style: const TextStyle(color: AppColors.gray),
      ),
    ],
  );

  Widget _buildBookButton(DoctorModel doc) => SizedBox(
    width: double.infinity,
    height: 55,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      onPressed: () {
        final clinicIdValue = doc.clinic?.id;
        final int validClinicId = int.tryParse(clinicIdValue.toString()) ?? 10;

        print("سأقوم الآن بإرسال الـ ID كـ رقم صحيح: $validClinicId");

        Get.to(
          () => AppointmentView(doctorId: doc.id, clinicId: validClinicId),
        );
      },
      child: const Text(
        'Book Appointment',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
