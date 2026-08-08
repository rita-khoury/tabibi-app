import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import '../../auth/data/models/LookupModel.dart';
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
                            [_buildBloodTypeSection()],
                          ),

                          _buildStep(
                            "Allergies",
                            "Select your known allergies",
                            "help_allergy",
                            [
                              _buildLookupChipsSection(
                                "Choose Allergies",
                                controller.allergyList,
                                controller.selectedAllergies,
                              ),
                            ],
                          ),

                          _buildStep(
                            "Health Status",
                            "Chronic Conditions & Symptoms",
                            "help_details",
                            [
                              _buildLookupChipsSection(
                                "Select Chronic Conditions",
                                controller.chronicList,
                                controller.selectedChronic,
                              ),
                              const SizedBox(height: 10),
                              _buildField(
                                controller.symptomsController,
                                "Current symptoms (optional)",
                                Icons.sick,
                              ),
                              _buildField(
                                controller.disabilityController,
                                "Disability info (optional)",
                                Icons.accessible,
                              ),
                            ],
                          ),

                          _buildStep(
                            "Medical History",
                            "Medications & Surgeries",
                            "help_history",
                            [
                              _buildLookupChipsSection(
                                "Select Past Surgeries",
                                controller.surgeryList,
                                controller.selectedSurgeries,
                              ),
                              const SizedBox(height: 15),
                              _buildLookupChipsSection(
                                "Select Current Medications",
                                controller.medicationList,
                                controller.selectedMedications,
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
        return "Selecting your allergies ensures your safety.";
      case "help_details":
        return "Information about chronic conditions helps in personalized care.";
      case "help_history":
        return "Past surgeries and medications assist in accurate diagnosis.";
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
  ) => SingleChildScrollView(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
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
        const SizedBox(height: 35),
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

  Widget _buildBloodTypeSection() => Wrap(
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

  Widget _buildLookupChipsSection(
    String label,
    RxList<LookupModel> items,
    RxList<String> selectedList,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Obx(() {
          if (items.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Text(
                "No predefined options available. You can write your condition or skip.",
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            );
          }
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.map((lookup) {
              final displayItem = lookup.labelEn.isNotEmpty
                  ? lookup.labelEn
                  : lookup.value;
              return Obx(() {
                final isSelected = selectedList.contains(displayItem);
                return GestureDetector(
                  onTap: () {
                    if (isSelected) {
                      selectedList.remove(displayItem);
                    } else {
                      selectedList.add(displayItem);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Text(
                      displayItem,
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.primaryBlue
                            : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              });
            }).toList(),
          );
        }),
      ],
    );
  }

  Widget _buildHeader() => Padding(
    padding: const EdgeInsets.all(24),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: controller.skipProfile,
          child: const Text(
            "Skip",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
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
          if (controller.currentStep.value > 0) const SizedBox(width: 15),
          Expanded(
            flex: 2,
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
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
