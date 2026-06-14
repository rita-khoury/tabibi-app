import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/appointment_controller.dart';
import 'package:tabibi/core/constance/app_colors.dart';

class AppointmentView extends GetView<AppointmentController> {
  const AppointmentView({super.key});

  void _processFinalBooking() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.calendar_month_outlined, color: AppColors.primaryBlue, size: 40),
              const SizedBox(height: 12),
              const Text(
                "Confirm Appointment",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(height: 25, thickness: 1),
              Text(
                "Your appointment will be set on Day (${controller.selectedDate}) during the (${controller.selectedPeriod}) period. Do you want to proceed?",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey,
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Get.back(),
                      child: const Text("No"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Get.back(); // إغلاق الديالوج

                        // استدعاء الدالة المحدثة من الـ Controller لتشغيل الصوت والـ Snackbar معاً
                        controller.confirmAndPlaySound();
                      },
                      child: const Text("Yes", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
        builder: (_) {
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
                        _sectionTitle("Appointment Type", Icons.medical_services),
                        const SizedBox(height: 12),
                        _typeRow(),
                      ],
                    ),
                  ),
                ),
                _confirmButton(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primaryBlue),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
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
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
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
                icon: const Icon(Icons.calendar_month, color: AppColors.primaryBlue),
                onPressed: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: AppColors.primaryBlue,
                            onPrimary: Colors.white,
                            surface: Colors.white,
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

                  if (picked != null) {
                    controller.selectedDate = picked.day.toString();
                    controller.update();
                  }
                },
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: controller.nextDays.map((date) {
              final isSelected = controller.selectedDate == date.day.toString();

              return GestureDetector(
                onTap: () {
                  controller.selectDate(date.day.toString());
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryBlue : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? Colors.transparent : Colors.grey.shade300,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _weekday(date.weekday),
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        date.day.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black,
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

  String _weekday(int d) {
    const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return days[d - 1];
  }

  Widget _periodRow() {
    return Row(
      children: [
        _chip("Morning", controller.selectedPeriod, controller.selectPeriod),
        _chip("Afternoon", controller.selectedPeriod, controller.selectPeriod),
        _chip("Evening", controller.selectedPeriod, controller.selectPeriod),
      ],
    );
  }

  Widget _typeRow() {
    return Row(
      children: [
        _chip("Consultation", controller.selectedType, controller.selectType),
        _chip("Follow-up", controller.selectedType, controller.selectType),
        _chip("Advice", controller.selectedType, controller.selectType),
      ],
    );
  }

  Widget _chip(String text, String selected, Function(String) onTap) {
    final isSelected = selected == text;

    return Expanded(
      child: GestureDetector(
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
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _confirmButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () {
          if (!controller.showTermsDialog) {
            _processFinalBooking();
            return;
          }

          Get.dialog(
            Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: GetBuilder<AppointmentController>(
                  builder: (logic) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: AppColors.primaryBlue,
                          size: 40,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Booking Terms & Conditions",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const Divider(height: 25, thickness: 1),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Column(
                            children: [
                              _buildPolicyRow(
                                icon: Icons.payments_outlined,
                                iconColor: Colors.green,
                                title: "Checkup Fee:",
                                description: "100 S.P will be deducted upon booking.",
                              ),
                              const SizedBox(height: 14),
                              _buildPolicyRow(
                                icon: Icons.check_circle_outline,
                                iconColor: AppColors.primaryBlue,
                                title: "Cancellation:",
                                description: "If canceled within the allowed time, you'll receive a full refund.",
                              ),
                              const SizedBox(height: 14),
                              _buildPolicyRow(
                                icon: Icons.warning_amber_rounded,
                                iconColor: Colors.orange,
                                title: "No-Show (1st Time):",
                                description: "10% of the booking amount will be deducted.",
                              ),
                              const SizedBox(height: 14),
                              _buildPolicyRow(
                                icon: Icons.gavel_rounded,
                                iconColor: Colors.red,
                                title: "No-Show (2nd Time):",
                                description: "Your account will be permanently banned from the platform.",
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Theme(
                          data: ThemeData(
                            checkboxTheme: CheckboxThemeData(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            ),
                          ),
                          child: CheckboxListTile(
                            title: const Text(
                              "Don't show this again",
                              style: TextStyle(fontSize: 13, color: Colors.black54),
                            ),
                            value: !logic.showTermsDialog,
                            onChanged: (val) {
                              logic.toggleShowTerms(!(val ?? false));
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                            activeColor: AppColors.primaryBlue,
                            dense: true,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.grey,
                                  side: BorderSide(color: Colors.grey.shade300),
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () => Get.back(),
                                child: const Center(
                                  child: Text(
                                    "Cancel",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryBlue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {
                                  Get.back();
                                  _processFinalBooking();
                                },
                                child: const Center(
                                  child: Text(
                                    "Accept & Confirm",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
            barrierDismissible: false,
          );
        },
        child: const Text(
          "Confirm",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildPolicyRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.4),
              children: [
                TextSpan(
                  text: "$title ",
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                ),
                TextSpan(text: description),
              ],
            ),
          ),
        ),
      ],
    );
  }
}