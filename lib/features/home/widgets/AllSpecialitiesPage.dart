import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constance/app_colors.dart';
import '../controller/home_controller.dart';
import '../widgets/specialities_section.dart';

class AllSpecialitiesPage extends StatelessWidget {
  const AllSpecialitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.primaryBlue,
          ),
          onPressed: Get.back,
        ),
        title: const Text(
          'All Specialities',
          style: TextStyle(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isSpecialitiesLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final error = controller.specialitiesErrorMessage.value;
        if (error != null) {
          return _SpecialitiesError(
            message: error,
            onRetry: controller.loadSpecialities,
          );
        }
        if (controller.specialities.isEmpty) {
          return Center(
            child: Text(
              'No specialities available at the moment.',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          );
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: SpecialitiesSection(
            isGrid: true,
            specialities: controller.specialities,
          ),
        );
      }),
    );
  }
}

class _SpecialitiesError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _SpecialitiesError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 52, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
