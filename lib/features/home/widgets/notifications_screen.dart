import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/app_colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    const Color backgroundColor = AppColors.white;
    const Color primaryColor = AppColors.primaryBlue;
    const Color subtitleColor = AppColors.gray;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(

          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.06),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/images/message-received-1-24 (1).png',
                  width: 140,
                  height: 140,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                "No new updates from doctors",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "We will let you know when you receive new notifications",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: subtitleColor,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}