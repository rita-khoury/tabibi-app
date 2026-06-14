import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tabibi/core/constance/app_colors.dart';
import '../controller/favorites_doctors_controller.dart';

class FavoritesDoctorsView extends GetView<FavoritesDoctorsController> {
  const FavoritesDoctorsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,

      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        centerTitle: true,
        title: const Text(
          "Favorite Doctors",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.primaryBlue,
                    AppColors.lightBlue,
                  ],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Row(
                children: [
                  Icon(Icons.favorite, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    "Your Trusted Doctors",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // LIST
            Expanded(
              child: Obx(() {

              if (controller.favorites.isEmpty) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/photo5.png.png',
          height: 180,
        ),
        const SizedBox(height: 20),
        const Text(
          "No Favorite Doctors Yet",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.gray,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Start adding doctors to your favorites",
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  );
}

                return ListView.builder(
                  itemCount: controller.favorites.length,
                  itemBuilder: (context, index) {
                    final doctor = controller.favorites[index];

                    return _doctorCard(index, doctor["name"]!, doctor["specialty"]!);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _doctorCard(int index, String name, String specialty) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [

          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: AppColors.lightBlue.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.person,
              color: AppColors.primaryBlue,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.gray,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  specialty,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () {
              controller.removeFavorite(index);
            },
            icon: const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}