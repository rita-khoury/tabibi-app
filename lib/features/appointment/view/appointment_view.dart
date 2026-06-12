import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/appointment_controller.dart';
import 'package:tabibi/core/constance/app_colors.dart';

class AppointmentView extends GetView<AppointmentController> {
  const AppointmentView({super.key});

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


                _confirmButton(),
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
        Text(title,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold)),
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
            color: Colors.black.withOpacity(0.05),
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
                icon: const Icon(Icons.calendar_month,
                    color: AppColors.primaryBlue),
                onPressed: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
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
              final isSelected =
                  controller.selectedDate == date.day.toString();

              return GestureDetector(
                onTap: () {
                  controller.selectDate(date.day.toString());
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryBlue
                        : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _weekday(date.weekday),
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        date.day.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : Colors.black,
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
    const days = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"];
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
            color: isSelected
                ? AppColors.primaryBlue
                : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade300),
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


  Widget _confirmButton() {
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
        onPressed: () {},
        child: const Text(
          "Confirm",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}