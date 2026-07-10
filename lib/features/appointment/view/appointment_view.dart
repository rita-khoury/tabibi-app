import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controller/appointment_controller.dart';
import 'package:tabibi/core/constance/app_colors.dart';

class AppointmentView extends GetView<AppointmentController> {
  const AppointmentView({super.key});

  void _processFinalBooking() {
    if (controller.selectedType == '' || controller.selectedPeriod == '') {
      Get.snackbar("خطأ", "يرجى تحديد الفترة ونوع الموعد");
      return;
    }

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Column(
          children: [
            Icon(Icons.calendar_month, size: 48, color: AppColors.primaryBlue),
            SizedBox(height: 16),
            Text(
              "Confirm Appointment",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          "Your appointment will be set on Day (${controller.selectedDate.day}) during the (${controller.selectedPeriod}) period. Do you want to proceed?",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade700, height: 1.4),
        ),
        actionsPadding: const EdgeInsets.all(16),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey.shade600,
                    side: BorderSide(color: Colors.grey.shade400),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text("No"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    _processActualBooking();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text("Yes"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _processActualBooking() {
    controller.submitAppointment(doctorId: 1, clinicId: 1);
  }

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AppointmentController>()) {
      Get.put(AppointmentController());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Book Appointment",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: GetBuilder<AppointmentController>(
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _dateCard(context),
                        const SizedBox(height: 25),
                        _sectionTitle("Select Period", Icons.access_time),
                        const SizedBox(height: 12),
                        _periodRow(),
                        const SizedBox(height: 25),
                        _sectionTitle(
                          "Appointment Type",
                          Icons.medical_services,
                        ),
                        const SizedBox(height: 12),
                        _typeRow(),
                      ],
                    ),
                  ),
                ),
                _confirmButton(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _typeRow() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: controller.appointmentTypes.map((type) {
        return SizedBox(
          width: (Get.width - 60) / 2,
          child: _chip(type, controller.selectedType, controller.selectType),
        );
      }).toList(),
    );
  }

  Widget _dateCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Select Date",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(
                  Icons.calendar_month,
                  color: AppColors.primaryBlue,
                ),
                onPressed: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: controller.selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),

                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: AppColors.primaryBlue,
                            onPrimary: Colors.white,
                            onSurface: Colors.black,
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primaryBlue,
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) controller.selectDate(picked);
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: controller.nextDays.map((date) {
              final selected =
                  controller.selectedDate.day == date.day &&
                  controller.selectedDate.month == date.month;
              return GestureDetector(
                onTap: () => controller.selectDate(date),
                child: Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primaryBlue : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected
                          ? Colors.transparent
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _weekday(date.weekday),
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.black,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        date.day.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selected ? Colors.white : Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primaryBlue),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  String _weekday(int day) {
    return ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][day - 1];
  }

  Widget _periodRow() {
    return Row(
      children: [
        Expanded(
          child: _chip(
            "Morning",
            controller.selectedPeriod,
            controller.selectPeriod,
          ),
        ),
        Expanded(
          child: _chip(
            "Afternoon",
            controller.selectedPeriod,
            controller.selectPeriod,
          ),
        ),
        Expanded(
          child: _chip(
            "Evening",
            controller.selectedPeriod,
            controller.selectPeriod,
          ),
        ),
      ],
    );
  }

  Widget _chip(String text, String selected, Function(String) onTap) {
    final bool isSelected = selected == text;
    return GestureDetector(
      onTap: () => onTap(text),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.black,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _confirmButton() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: controller.isLoading.value
              ? null
              : () {
                  final box = GetStorage();
                  bool shouldHide = box.read('hideTerms') ?? false;

                  if (shouldHide) {
                    _processFinalBooking();
                  } else {
                    _showTermsDialog();
                  }
                },
          child: controller.isLoading.value
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  "Confirm",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
        ),
      ),
    );
  }

  void _showTermsDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titlePadding: const EdgeInsets.only(top: 24, bottom: 8),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        title: const Column(
          children: [
            Icon(Icons.info_outline, size: 48, color: AppColors.primaryBlue),
            SizedBox(height: 16),
            Text(
              "Booking Terms & Conditions",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              ListBody(
                children: [
                  _buildRichText(
                    "Checkup Fee:",
                    " 100 S.P will be deducted upon booking.",
                    Icons.attach_money,
                    Colors.green,
                  ),
                  const SizedBox(height: 12),
                  _buildRichText(
                    "Cancellation:",
                    " If canceled within the allowed time, you'll receive a full refund.",
                    Icons.check_circle_outline,
                    Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  _buildRichText(
                    "No-Show (1st Time):",
                    " 10% of the booking amount will be deducted.",
                    Icons.warning_amber_rounded,
                    Colors.orange,
                  ),
                  const SizedBox(height: 12),
                  _buildRichText(
                    "No-Show (2nd Time):",
                    " Your account will be permanently banned from the platform.",
                    Icons.gavel,
                    Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Obx(
                () => CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text(
                    "Don't show again",
                    style: TextStyle(fontSize: 14),
                  ),
                  value: controller.dontShowAgain.value,
                  onChanged: (val) => controller.dontShowAgain.value = val!,
                  activeColor: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.all(16),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey.shade600,
                    side: BorderSide(color: Colors.grey.shade400),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text("Cancel"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    controller.saveTermsPreference();
                    Get.back();
                    _processFinalBooking();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text("Accept & Confirm"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _buildRichText(
    String stringTitle,
    String stringBody,
    IconData icon,
    Color iconColor,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.grey.shade800,
                height: 1.4,
                fontSize: 14,
              ),
              children: [
                TextSpan(
                  text: stringTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: stringBody),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
