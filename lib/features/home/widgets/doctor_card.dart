import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../doctor_profile/view/doctor_profile_view.dart';

class DoctorCard extends StatelessWidget {
  final Map doc;

  const DoctorCard({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    // استخراج البيانات مع قيم افتراضية لتجنب الـ null
    final String name = doc["name"]?.toString() ?? "Unknown Doctor";
    final String speciality = doc["speciality"]?.toString() ?? "General";
    final String imageUrl = doc["image"]?.toString() ?? "";
    final String rating = doc["rating"]?.toString() ?? "0.0";

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Row(
        children: [
          // جزء الصورة
          Stack(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey[200],
                  image: imageUrl.isNotEmpty
                      ? DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                child: imageUrl.isEmpty
                    ? const Icon(Icons.person, color: Colors.grey)
                    : null,
              ),
              Positioned(
                top: -3,
                right: -3,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 12),

          // جزء النصوص
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  speciality,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 16),
                    const SizedBox(width: 4),
                    Text(rating),
                  ],
                ),
              ],
            ),
          ),

          // زر الحجز
          ElevatedButton(
            onPressed: () {
              Get.to(() => DoctorProfileView(), arguments: doc);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              elevation: 0,
            ),
            child: const Text('Book', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}