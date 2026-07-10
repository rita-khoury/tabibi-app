import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import '../controller/complete_profile_controller.dart';

class CompleteProfileView extends StatelessWidget {
  final CompleteProfileController controller = Get.put(
    CompleteProfileController(),
  );

  CompleteProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF64B5F6), Color(0xFF42A5F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Obx(
                  () =>
                      IndexedStack(
                        index: controller.currentStep.value,
                        children: [
                          _buildWelcomeStep(),
                          _buildStep(
                            "Personal",
                            "What is your blood type?",
                            "help_blood",
                            [_buildBloodTypeSection("Blood Type")],
                          ),
                          _buildStep(
                            "Allergies",
                            "Known allergies?",
                            "help_allergy",
                            [
                              _buildField(
                                controller.allergiesController,
                                "e.g., Penicillin, Dust",
                                Icons.warning_amber_rounded,
                              ),
                            ],
                          ),
                          _buildStep(
                            "Health Status",
                            "Symptoms & Disability",
                            "help_details",
                            [
                              _buildField(
                                controller.symptomsController,
                                "Current symptoms",
                                Icons.sick,
                              ),
                              _buildField(
                                controller.disabilityController,
                                "Disability info",
                                Icons.accessible,
                              ),
                            ],
                          ),
                          _buildStep(
                            "Medical History",
                            "Medications & Surgeries",
                            "help_history",
                            [
                              _buildField(
                                controller.medicationsController,
                                "Current medications",
                                Icons.medication,
                              ),
                              _buildField(
                                controller.surgeriesController,
                                "Past surgeries",
                                Icons.local_hospital,
                              ),
                            ],
                          ),
                          _buildStep(
                            "Lifestyle",
                            "Habits & Family History",
                            "help_lifestyle",
                            [
                              _buildField(
                                controller.lifestyleController,
                                "Lifestyle habits",
                                Icons.directions_run,
                              ),
                              _buildField(
                                controller.familyHistoryController,
                                "Family history",
                                Icons.family_restroom,
                              ),
                            ],
                          ),
                        ],
                      ),
                ),
              ),
              _buildFooter(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  String _getHelpText(String key) {
    switch (key) {
      case "help_blood":
        return "Knowing your blood type is essential for medical emergencies.";
      case "help_allergy":
        return "Listing your allergies ensures your safety.";
      case "help_details":
        return "Information about symptoms and disability helps in personalized care.";
      case "help_history":
        return "Past surgeries and current meds assist in accurate diagnosis.";
      case "help_lifestyle":
        return "Your habits and family history are key to long-term health.";
      default:
        return "";
    }
  }

  Widget _buildWelcomeStep() => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Obx(
        () =>
            Icon(controller.currentIcon.value, color: Colors.white, size: 100),
      ),
      const SizedBox(height: 30),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Obx(
          () => Text(
            controller.currentText.value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ],
  );

  Widget _buildStep(
    String title,
    String question,
    String helpKey,
    List<Widget> children,
  ) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          question,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _getHelpText(helpKey),
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 14,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 48),
        ...children.map(
          (child) =>
              Padding(padding: const EdgeInsets.only(bottom: 20), child: child),
        ),
      ],
    ),
  );

  Widget _buildField(TextEditingController ctrl, String hint, IconData icon) =>
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: TextField(
          controller: ctrl,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.primaryBlue),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 20,
            ),
          ),
        ),
      );

  Widget _buildBloodTypeSection(String label) => Wrap(
    spacing: 10,
    runSpacing: 10,
    children: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-']
        .map(
          (t) => Obx(
            () => GestureDetector(
              onTap: () => controller.bloodType.value = t,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: controller.bloodType.value == t
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  t,
                  style: TextStyle(
                    color: controller.bloodType.value == t
                        ? AppColors.primaryBlue
                        : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        )
        .toList(),
  );

  Widget _buildHeader() => Padding(
    padding: const EdgeInsets.all(24),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: controller.skipProfile,
          child: const Text("Skip", style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );

  Widget _buildFooter() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Obx(
      () => Row(
        children: [
          if (controller.currentStep.value > 0)
            Expanded(
              child: TextButton(
                onPressed: controller.previousStep,
                child: const Text(
                  "Back",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          Expanded(
            child: ElevatedButton(
              onPressed: controller.currentStep.value == 5
                  ? controller.submitCompleteProfile
                  : controller.nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primaryBlue,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                controller.currentStep.value == 5 ? "Finish" : "Next",
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
