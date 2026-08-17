import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import 'package:tabibi/features/auth/repository/AuthController.dart';
import 'package:tabibi/features/medical_records/controller/medical_records_controller.dart';
import 'package:tabibi/features/profile/controller/profile_controller.dart';
import 'package:tabibi/features/medical_records/model/medical_record_model.dart';

class MedicalProfileEditorView extends StatefulWidget {
  const MedicalProfileEditorView({super.key});

  @override
  State<MedicalProfileEditorView> createState() =>
      _MedicalProfileEditorViewState();
}

class _MedicalProfileEditorViewState extends State<MedicalProfileEditorView> {
  final MedicalRecordController controller =
      Get.find<MedicalRecordController>();

  final currentSymptomsController = TextEditingController();
  final familyHistoryController = TextEditingController();
  final medicationsController = TextEditingController();
  final vaccinationController = TextEditingController();

  String? selectedBloodType;
  String? selectedPregnancyStatus;
  String? selectedDisability;

  final selectedAllergies = <String>[];
  final selectedChronicConditions = <String>[];
  final selectedSurgeries = <String>[];
  final selectedLifestyleHabits = <String>[];
  final familyHistory = <String>[];
  final currentMedications = <String>[];
  final vaccinationStatus = <String>[];

  bool noAllergies = false;
  bool noChronicConditions = false;
  bool noPastSurgeries = false;
  bool noLifestyleHabits = false;
  bool noCurrentSymptoms = false;

  bool allergiesAnswered = false;
  bool chronicConditionsAnswered = false;
  bool pastSurgeriesAnswered = false;
  bool lifestyleHabitsAnswered = false;
  bool currentSymptomsAnswered = false;

  bool get isEditing => controller.medicalProfile.value != null;

  String? _patientGender;
  bool _isLoadingPatientGender = true;

  bool get _isFemalePatient => _patientGender == 'FEMALE';

  Future<void> _resolvePatientGender() async {
    try {
      if (Get.isRegistered<ProfileController>()) {
        final profileController = Get.find<ProfileController>();
        if (profileController.profile.value == null &&
            Get.isRegistered<AuthController>()) {
          final userId = Get.find<AuthController>().currentUser.value?.id;
          if (userId != null && userId.isNotEmpty) {
            await profileController.fetchProfile(userId);
          }
        }
        _patientGender = profileController.profile.value?.gender
            .trim()
            .toUpperCase();
      }
    } catch (_) {
      _patientGender = null;
    } finally {
      if (mounted) setState(() => _isLoadingPatientGender = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _populateFromProfile(controller.medicalProfile.value);
    controller.loadMedicalProfileLookups();
    _resolvePatientGender();
  }

  void _populateFromProfile(MedicalProfileModel? profile) {
    if (profile == null) return;

    selectedBloodType = profile.bloodType;
    selectedPregnancyStatus = profile.pregnancyStatus;
    selectedDisability = profile.disabilityInfo;

    final symptoms = profile.currentSymptoms;
    currentSymptomsAnswered = symptoms != null;
    noCurrentSymptoms = symptoms == '';
    currentSymptomsController.text = noCurrentSymptoms ? '' : (symptoms ?? '');

    final allergies = profile.allergies;
    allergiesAnswered = allergies != null;
    noAllergies = allergies?.isEmpty ?? false;
    selectedAllergies.addAll(allergies ?? const <String>[]);

    final chronicConditions = profile.chronicConditions;
    chronicConditionsAnswered = chronicConditions != null;
    noChronicConditions = chronicConditions?.isEmpty ?? false;
    selectedChronicConditions.addAll(chronicConditions ?? const <String>[]);

    final pastSurgeries = profile.pastSurgeries;
    pastSurgeriesAnswered = pastSurgeries != null;
    noPastSurgeries = pastSurgeries?.isEmpty ?? false;
    selectedSurgeries.addAll(pastSurgeries ?? const <String>[]);

    final lifestyleHabits = profile.lifestyleHabits;
    lifestyleHabitsAnswered = lifestyleHabits != null;
    noLifestyleHabits = lifestyleHabits?.isEmpty ?? false;
    selectedLifestyleHabits.addAll(lifestyleHabits ?? const <String>[]);

    familyHistory.addAll(profile.familyHistory ?? const <String>[]);
    currentMedications.addAll(profile.currentMedications ?? const <String>[]);
    vaccinationStatus.addAll(profile.vaccinationStatus ?? const <String>[]);
  }

  @override
  void dispose() {
    currentSymptomsController.dispose();
    familyHistoryController.dispose();
    medicationsController.dispose();
    vaccinationController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_isLoadingPatientGender) {
      _showValidationError('Please wait while patient details are loading.');
      return;
    }
    if (selectedBloodType?.trim().isNotEmpty != true) {
      _showValidationError('Blood type is required.');
      return;
    }
    if (_isFemalePatient &&
        selectedPregnancyStatus?.trim().isNotEmpty != true) {
      _showValidationError('Pregnancy status is required for female patients.');
      return;
    }
    if (selectedDisability?.trim().isNotEmpty != true) {
      _showValidationError('Please answer disability information.');
      return;
    }
    if (!currentSymptomsAnswered) {
      _showValidationError('Please answer the current symptoms question.');
      return;
    }
    if (!allergiesAnswered ||
        !chronicConditionsAnswered ||
        !pastSurgeriesAnswered ||
        !lifestyleHabitsAnswered) {
      _showValidationError(
        'Please answer allergies, chronic conditions, past surgeries, and lifestyle habits.',
      );
      return;
    }

    final payload = <String, dynamic>{
      'bloodType': selectedBloodType,
      if (_isFemalePatient) 'pregnancyStatus': selectedPregnancyStatus,
      'disabilityInfo': selectedDisability,
      'currentSymptoms': noCurrentSymptoms
          ? ''
          : (currentSymptomsAnswered
                ? _nullableText(currentSymptomsController.text)
                : null),
      'allergies': allergiesAnswered
          ? List<String>.from(selectedAllergies)
          : null,
      'chronicConditions': chronicConditionsAnswered
          ? List<String>.from(selectedChronicConditions)
          : null,
      'pastSurgeries': pastSurgeriesAnswered
          ? List<String>.from(selectedSurgeries)
          : null,
      'familyHistory': List<String>.from(familyHistory),
      'currentMedications': List<String>.from(currentMedications),
      'lifestyleHabits': lifestyleHabitsAnswered
          ? List<String>.from(selectedLifestyleHabits)
          : null,
      'vaccinationStatus': List<String>.from(vaccinationStatus),
    };

    final saved = await controller.saveMedicalProfile(payload);
    if (!mounted) return;

    if (saved) {
      Navigator.of(context).pop(true);
      return;
    }

    final error =
        controller.lastProfileSaveError.value ??
        'Unable to save medical profile. Please try again.';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showValidationError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String? _nullableText(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryBlue),
          onPressed: () => Get.back(),
        ),
        title: Text(
          isEditing ? 'Edit Medical Profile' : 'Create Medical Profile',
          style: const TextStyle(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isProfileLookupsLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryBlue),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _introCard(),
              const SizedBox(height: 16),
              _sectionCard(
                title: 'Core details',
                children: [
                  _singleLookupField(
                    label: 'Blood type',
                    category: MedicalRecordController.bloodTypeLookupCategory,
                    value: selectedBloodType,
                    onChanged: (value) =>
                        setState(() => selectedBloodType = value),
                  ),
                  const SizedBox(height: 16),
                  if (_isLoadingPatientGender)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 10),
                          Text('Checking patient details...'),
                        ],
                      ),
                    )
                  else if (_isFemalePatient) ...[
                    _pregnancyField(),
                    const SizedBox(height: 16),
                  ],
                  _singleLookupField(
                    label: 'Disability information',
                    category:
                        MedicalRecordController.disabilityTypesLookupCategory,
                    value: selectedDisability,
                    onChanged: (value) =>
                        setState(() => selectedDisability = value),
                  ),
                  const SizedBox(height: 16),
                  FilterChip(
                    label: const Text('No current symptoms'),
                    selected: noCurrentSymptoms,
                    selectedColor: AppColors.lightBlue.withValues(alpha: 0.6),
                    checkmarkColor: AppColors.primaryBlue,
                    onSelected: (selected) {
                      setState(() {
                        noCurrentSymptoms = selected;
                        currentSymptomsAnswered = selected;
                        if (selected) currentSymptomsController.clear();
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: currentSymptomsController,
                    maxLines: 3,
                    decoration: _inputDecoration(
                      'Current symptoms',
                      'Describe current symptoms, if any',
                    ),
                    onChanged: (value) {
                      setState(() {
                        noCurrentSymptoms = false;
                        currentSymptomsAnswered = value.trim().isNotEmpty;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _sectionCard(
                title: 'Lookup selections',
                children: [
                  _multiLookupField(
                    label: 'Allergies',
                    category: MedicalRecordController.allergyLookupCategory,
                    selected: selectedAllergies,
                    noneLabel: 'No allergies',
                    noneSelected: noAllergies,
                    onNoneChanged: (value) => noAllergies = value,
                    onAnsweredChanged: (value) => allergiesAnswered = value,
                  ),
                  const SizedBox(height: 20),
                  _multiLookupField(
                    label: 'Chronic conditions',
                    category:
                        MedicalRecordController.chronicConditionLookupCategory,
                    selected: selectedChronicConditions,
                    noneLabel: 'No chronic conditions',
                    noneSelected: noChronicConditions,
                    onNoneChanged: (value) => noChronicConditions = value,
                    onAnsweredChanged: (value) =>
                        chronicConditionsAnswered = value,
                  ),
                  const SizedBox(height: 20),
                  _multiLookupField(
                    label: 'Past surgeries',
                    category:
                        MedicalRecordController.commonSurgeriesLookupCategory,
                    selected: selectedSurgeries,
                    noneLabel: 'No past surgeries',
                    noneSelected: noPastSurgeries,
                    onNoneChanged: (value) => noPastSurgeries = value,
                    onAnsweredChanged: (value) => pastSurgeriesAnswered = value,
                  ),
                  const SizedBox(height: 20),
                  _multiLookupField(
                    label: 'Lifestyle habits',
                    category:
                        MedicalRecordController.lifestyleHabitsLookupCategory,
                    selected: selectedLifestyleHabits,
                    noneLabel: 'No specific lifestyle habits',
                    noneSelected: noLifestyleHabits,
                    onNoneChanged: (value) => noLifestyleHabits = value,
                    onAnsweredChanged: (value) =>
                        lifestyleHabitsAnswered = value,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _sectionCard(
                title: 'Additional medical information',
                children: [
                  _freeTextListField(
                    label: 'Family history',
                    hint: 'Add one family-history item',
                    values: familyHistory,
                    textController: familyHistoryController,
                  ),
                  const SizedBox(height: 20),
                  _freeTextListField(
                    label: 'Current medications',
                    hint: 'Add one medication',
                    values: currentMedications,
                    textController: medicationsController,
                  ),
                  const SizedBox(height: 20),
                  _freeTextListField(
                    label: 'Vaccination status',
                    hint: 'Add one vaccination item',
                    values: vaccinationStatus,
                    textController: vaccinationController,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: controller.isProfileSaving.value ? null : _save,
                  icon: controller.isProfileSaving.value
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(
                    isEditing ? 'Save changes' : 'Create medical profile',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  Widget _introCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.lightBlue.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Select available options where provided. The remaining profile fields accept the information exactly as stored by the medical profile API.',
        style: TextStyle(color: AppColors.gray, height: 1.35),
      ),
    );
  }

  Widget _sectionCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _singleLookupField({
    required String label,
    required String category,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    final options = controller.lookupOptionsFor(category);
    final values = options.map((option) => option.value).toSet();
    final items = <MedicalProfileLookupOption>[...options];
    if (value != null && value.isNotEmpty && !values.contains(value)) {
      items.insert(
        0,
        MedicalProfileLookupOption(
          value: value,
          labelEn: value,
          labelAr: value,
        ),
      );
    }

    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      decoration: _inputDecoration(label, 'Select an option'),
      items: [
        const DropdownMenuItem<String>(
          value: null,
          child: Text('Not provided'),
        ),
        ...items.map(
          (option) => DropdownMenuItem<String>(
            value: option.value,
            child: Text(option.displayLabel, overflow: TextOverflow.ellipsis),
          ),
        ),
      ],
      onChanged: items.isEmpty ? null : onChanged,
    );
  }

  Widget _pregnancyField() {
    const statuses = <String>['NOT_PREGNANT', 'PREGNANT', 'BREASTFEEDING'];
    return DropdownButtonFormField<String>(
      value: selectedPregnancyStatus,
      decoration: _inputDecoration('Pregnancy status', 'Select if applicable'),
      items: const [
        DropdownMenuItem<String>(value: null, child: Text('Not provided')),
        DropdownMenuItem<String>(
          value: 'NOT_PREGNANT',
          child: Text('Not pregnant'),
        ),
        DropdownMenuItem<String>(value: 'PREGNANT', child: Text('Pregnant')),
        DropdownMenuItem<String>(
          value: 'BREASTFEEDING',
          child: Text('Breastfeeding'),
        ),
      ],
      onChanged: (value) {
        if (value == null || statuses.contains(value)) {
          setState(() => selectedPregnancyStatus = value);
        }
      },
    );
  }

  Widget _multiLookupField({
    required String label,
    required String category,
    required List<String> selected,
    required String noneLabel,
    required bool noneSelected,
    required ValueChanged<bool> onNoneChanged,
    required ValueChanged<bool> onAnsweredChanged,
  }) {
    final options = controller.lookupOptionsFor(category);
    final optionByValue = <String, MedicalProfileLookupOption>{
      for (final option in options) option.value: option,
    };
    final selectedOutsideOptions = selected
        .where((value) => !optionByValue.containsKey(value))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilterChip(
              label: Text(noneLabel),
              selected: noneSelected,
              selectedColor: AppColors.lightBlue.withValues(alpha: 0.6),
              checkmarkColor: AppColors.primaryBlue,
              onSelected: (enabled) {
                setState(() {
                  selected.clear();
                  onNoneChanged(enabled);
                  onAnsweredChanged(enabled);
                });
              },
            ),
            ...options.map((option) {
              final isSelected = selected.contains(option.value);
              return FilterChip(
                label: Text(option.displayLabel),
                selected: isSelected,
                selectedColor: AppColors.lightBlue.withValues(alpha: 0.6),
                checkmarkColor: AppColors.primaryBlue,
                onSelected: (enabled) {
                  setState(() {
                    if (enabled) {
                      selected.add(option.value);
                      onNoneChanged(false);
                    } else {
                      selected.remove(option.value);
                    }
                    onAnsweredChanged(selected.isNotEmpty);
                  });
                },
              );
            }),
          ],
        ),
        if (options.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'No active backend options are currently available.',
              style: TextStyle(color: AppColors.gray),
            ),
          ),
        if (selectedOutsideOptions.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: selectedOutsideOptions
                .map(
                  (value) => InputChip(
                    label: Text(value),
                    onDeleted: () => setState(() {
                      selected.remove(value);
                      onAnsweredChanged(selected.isNotEmpty);
                    }),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }

  Widget _freeTextListField({
    required String label,
    required String hint,
    required List<String> values,
    required TextEditingController textController,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: textController,
                decoration: _inputDecoration('', hint),
                onSubmitted: (_) => _addListValue(values, textController),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.add_circle, color: AppColors.primaryBlue),
              onPressed: () => _addListValue(values, textController),
            ),
          ],
        ),
        if (values.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: values
                .map(
                  (value) => InputChip(
                    label: Text(value),
                    onDeleted: () => setState(() => values.remove(value)),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }

  void _addListValue(
    List<String> values,
    TextEditingController textController,
  ) {
    final value = textController.text.trim();
    if (value.isEmpty || values.contains(value)) return;
    setState(() {
      values.add(value);
      textController.clear();
    });
  }

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label.isEmpty ? null : label,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.lightGray),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primaryBlue),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
    );
  }
}
