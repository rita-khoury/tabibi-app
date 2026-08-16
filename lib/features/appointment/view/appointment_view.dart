import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controller/appointment_controller.dart';
import 'package:tabibi/core/constance/app_colors.dart';

class AppointmentView extends GetView<AppointmentController> {
  final int doctorId;
  final int? clinicId;
  final int? referralId;
  final String? referralSourceName;

  const AppointmentView({super.key, required this.doctorId, this.clinicId, this.referralId, this.referralSourceName});

  void _showFinalBookingDialog() {
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
          "Your appointment will be set on Day (${controller.selectedDate.day}) at (${controller.selectedTimeSlot.value?['startTime'] ?? ''} - ${controller.selectedTimeSlot.value?['endTime'] ?? ''}). Do you want to proceed?",
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
    controller.submitAppointment(doctorId: doctorId);
  }

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AppointmentController>()) {
      Get.put(AppointmentController());
    }
    controller.setReferralContext(
      referralId: referralId,
      sourceDoctorName: referralSourceName,
    );
    controller.fetchClinics(doctorId, preferredClinicId: clinicId);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.primaryBlue,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Book Appointment",
          style: TextStyle(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: GetBuilder<AppointmentController>(
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                if (referralId != null)
                  _referralBookingBanner(
                    sourceDoctorName: referralSourceName,
                  ),
                if (referralId != null) const SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _dateCard(context),
                        const SizedBox(height: 25),
                        if (controller.isSelectedDayFull)
                          _periodRow()
                        else ...[
                          _sectionTitle("Select Period", Icons.access_time),
                          const SizedBox(height: 12),
                          _periodRow(),
                          const SizedBox(height: 16),
                          _sectionTitle(
                            "Appointment Type",
                            Icons.medical_services,
                          ),
                          const SizedBox(height: 12),
                          _typeRow(),
                          const SizedBox(height: 25),
                          _sectionTitle('Available Time', Icons.schedule),
                          const SizedBox(height: 12),
                          _timeSlotRow(),
                        ],
                      ],
                    ),
                  ),
                ),
                if (!controller.isSelectedDayFull) _confirmButton(),
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
          child: _chip(
            type,
            controller.selectedType,
            (value) => controller.selectType(value, doctorId: doctorId),
          ),
        );
      }).toList(),
    );
  }

  Widget _referralBookingBanner({String? sourceDoctorName}) {
    final source = sourceDoctorName?.trim().isNotEmpty == true
        ? sourceDoctorName!.trim()
        : 'your doctor';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.assignment_turned_in_outlined,
              color: AppColors.primaryBlue),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Booking via referral from $source',
              style: const TextStyle(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
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
                    selectableDayPredicate: controller.isAvailableDay,
                    builder: (context, child) => Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: AppColors.primaryBlue,
                          onPrimary: Colors.white,
                          onSurface: Colors.black,
                        ),
                      ),
                      child: child!,
                    ),
                  );
                  if (picked != null) {
                    controller.selectDate(picked, doctorId: doctorId);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: controller.doctorAvailableDays.map((date) {
                final selected =
                    controller.selectedDate.day == date.day &&
                    controller.selectedDate.month == date.month &&
                    controller.selectedDate.year == date.year;
                final isFull = controller.isFullDate(date);

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () =>
                        controller.selectDate(date, doctorId: doctorId),
                    child: Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primaryBlue
                            : isFull
                            ? Colors.red.shade50
                            : Colors.blue.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selected
                              ? Colors.transparent
                              : isFull
                              ? Colors.red.shade300
                              : AppColors.primaryBlue.withValues(alpha: 0.4),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _weekday(date.weekday),
                            style: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : isFull
                                  ? Colors.red.shade700
                                  : AppColors.primaryBlue,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            date.day.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: selected
                                  ? Colors.white
                                  : isFull
                                  ? Colors.red.shade700
                                  : Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
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

  String _weekday(int day) =>
      ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][day - 1];

  Widget _periodRow() {
    if (controller.isSelectedDayFull) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'This day is full and cannot be booked.',
              style: TextStyle(color: Colors.red, fontSize: 13),
            ),
          ),
          if (controller.isCheckingWaitlistMembership)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text('Checking waitlist status...'),
                ],
              ),
            )
          else if (controller.isAlreadyOnWaitlist)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                border: Border.all(color: Colors.green.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 18,
                    color: Colors.green.shade700,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Already on waitlist',
                    style: TextStyle(
                      color: Colors.green.shade800,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          else if (controller.canJoinWaitlist)
            TextButton.icon(
              onPressed: () => controller.joinSelectedDayWaitlist(doctorId),
              icon: const Icon(Icons.notifications_active_outlined),
              label: const Text('Join waitlist'),
            )
          else if (controller.hasWaitlistMembershipCheckFailed)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Unable to verify waitlist status. Please try again.',
                style: TextStyle(color: Colors.orange, fontSize: 13),
              ),
            ),
        ],
      );
    }

    if (controller.availablePeriodsForSelectedDay.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          'No normal schedules are available for this day.',
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: controller.availablePeriodsForSelectedDay.map((period) {
        final unavailable = controller.isScheduleUnavailable(period);
        final selected = !unavailable && controller.selectedPeriod == period;
        return SizedBox(
          width: 150,
          child: _scheduleChip(
            period,
            unavailable: unavailable,
            selected: selected,
            onTap: unavailable
                ? null
                : () => controller.selectPeriod(period, doctorId: doctorId),
          ),
        );
      }).toList(),
    );
  }

  Widget _scheduleChip(
    String text, {
    required bool unavailable,
    required bool selected,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: unavailable
              ? Colors.red.shade50
              : selected
              ? AppColors.primaryBlue
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: unavailable
                ? Colors.red.shade300
                : selected
                ? Colors.transparent
                : Colors.grey.shade300,
          ),
        ),
        child: Center(
          child: Text(
            unavailable ? '$text (Full)' : text,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: unavailable
                  ? Colors.red.shade700
                  : selected
                  ? Colors.white
                  : Colors.black,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _timeSlotRow() {
    if (controller.isSelectedDayFull) {
      return const SizedBox.shrink();
    }
    if (controller.selectedPeriod.isEmpty) {
      return const Text(
        'Select a normal schedule to load its next available appointment time.',
        style: TextStyle(color: Colors.grey, fontSize: 13),
      );
    }
    if (controller.availableTimeSlots.isEmpty) {
      return const Text(
        'No appointment time is currently available for this schedule.',
        style: TextStyle(color: Colors.redAccent, fontSize: 13),
      );
    }

    final selectedSlot = controller.selectedTimeSlot.value;
    final selectedLabel = selectedSlot == null
        ? ''
        : '${selectedSlot['startTime']} - ${selectedSlot['endTime']}';
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: controller.availableTimeSlots.map((slot) {
        final label = '${slot['startTime']} - ${slot['endTime']}';
        return SizedBox(
          width: 150,
          child: _chip(
            label,
            selectedLabel,
            (_) => controller.selectTimeSlot(slot),
          ),
        );
      }).toList(),
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
          onPressed:
              controller.isLoading.value || !controller.hasSelectedFinalTime
              ? null
              : () {
                  if (controller.selectedPeriod.isEmpty ||
                      controller.selectedType.isEmpty ||
                      !controller.hasSelectedFinalTime) {
                    Get.snackbar(
                      "خطأ",
                      "يرجى تحديد الفترة ونوع الموعد",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  controller.checkProfileAndProceed(() {
                    bool shouldHide = GetStorage().read('hideTerms') ?? false;

                    if (shouldHide) {
                      _showFinalBookingDialog();
                    } else {
                      _showTermsDialog();
                    }
                  });
                },
          child: controller.isLoading.value
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  "Confirm Appointment",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
        ),
      ),
    );
  }

  Future<void> _showTermsDialog() async {
    await controller.loadBookingSummaryDoctor(doctorId);
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
              "Booking Summary & Terms",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRichText(
                "Appointment:",
                ' ${controller.bookingSummaryDoctor.value?.name ?? 'Doctor details unavailable'}',
                Icons.person_outline,
                AppColors.primaryBlue,
              ),
              const SizedBox(height: 10),
              _buildRichText(
                "Specialization:",
                ' ${controller.bookingSummaryDoctor.value?.specialization ?? 'Specialization unavailable'}',
                Icons.medical_services_outlined,
                AppColors.primaryBlue,
              ),
              const SizedBox(height: 10),
              _buildRichText(
                "Date:",
                ' ${controller.bookingSummaryRequestedDate}',
                Icons.calendar_today_outlined,
                AppColors.primaryBlue,
              ),
              const SizedBox(height: 10),
              _buildRichText(
                "Time:",
                ' ${controller.bookingSummaryTime}',
                Icons.access_time_outlined,
                AppColors.primaryBlue,
              ),
              const SizedBox(height: 10),
              _buildRichText(
                "Visit type:",
                ' ${controller.selectedType}',
                Icons.assignment_outlined,
                AppColors.primaryBlue,
              ),
              const SizedBox(height: 14),
              _buildRichText(
                "Consultation fee:",
                ' ${controller.bookingSummaryFee}',
                Icons.payments_outlined,
                Colors.green,
              ),
              const SizedBox(height: 16),
              _buildRichText(
                "Cancellation:",
                " Refundable according to the cancellation policy.",
                Icons.check_circle_outline,
                Colors.blue,
              ),
              const SizedBox(height: 12),
              _buildRichText(
                "No-show:",
                " Repeated no-shows may result in restrictions according to your violation record.",
                Icons.warning_amber_rounded,
                Colors.orange,
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
                    padding: const EdgeInsets.symmetric(vertical: 12),
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
                    _showFinalBookingDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text("Accept"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _buildRichText(String t, String b, IconData i, Color c) => Row(
    children: [
      Icon(i, size: 20, color: c),
      const SizedBox(width: 8),
      Expanded(
        child: RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.grey.shade800),
            children: [
              TextSpan(
                text: t,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: b),
            ],
          ),
        ),
      ),
    ],
  );
}
