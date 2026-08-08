import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constance/app_colors.dart';
import '../controller/SpecialitiesController.dart';
import '../widgets/specialities_section.dart';

class AllSpecialitiesPage extends StatelessWidget {
  const AllSpecialitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SpecialitiesController controller = Get.put(SpecialitiesController());

    return Scaffold(
      backgroundColor:  AppColors.lightGray,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.primaryBlue,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "All Specialities",
          style: TextStyle(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.lightGray,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.specialities.isEmpty) {
            return const Center(
              child: Text(
                "No specialities available at the moment.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return SpecialitiesSection(
            isGrid: true,
            specialities: controller.specialities,
          );
        }),
      ),
    );
  }
}
