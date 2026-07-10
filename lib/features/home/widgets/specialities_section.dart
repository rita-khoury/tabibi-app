import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/DoctorsPage.dart';
import '../../../core/services/doctor_service.dart';
import '../../../features/auth/data/models/DoctorModel.dart';

class SpecialitiesSection extends StatelessWidget {
  final bool isGrid;
  final DoctorService _service = DoctorService();

  SpecialitiesSection({super.key, this.isGrid = false});

  @override
  Widget build(BuildContext context) {
    final items = [
      {"icon": Icons.favorite_sharp, "title": "Cardiology"},
      {"icon": Icons.face_sharp, "title": "Dermatology"},
      {"icon": Icons.visibility_sharp, "title": "Optometry"},
      {"icon": Icons.medical_services_sharp, "title": "Dentistry"},
      {"icon": Icons.psychology_sharp, "title": "Brain & Nerves"},
      {"icon": Icons.accessible_sharp, "title": "Orthopedics"},
      {"icon": Icons.child_care_sharp, "title": "Pediatrics"},
      {"icon": Icons.hearing_sharp, "title": "ENT"},
      {"icon": Icons.pregnant_woman_sharp, "title": "Gynecology"},
    ];

    Widget buildItem(int index) {
      return InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () async {
          final rawData = await _service.getAll();
          final List<DoctorModel> doctorsList = rawData
              .map((e) => DoctorModel.fromJson(e))
              .toList();

          Get.to(
            () => DoctorsPage(
              speciality: items[index]["title"].toString(),
              doctors: doctorsList,
            ),
          );
        },
        child: Container(
          width: 90,
          height: 85,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xff2F80ED), Color(0xff56CCF2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff2F80ED).withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                items[index]["icon"] as IconData,
                color: Colors.white,
                size: 26,
              ),
              const SizedBox(height: 6),
              Text(
                items[index]["title"].toString(),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (isGrid) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 15,
          childAspectRatio: 1.1,
        ),
        itemBuilder: (context, index) => buildItem(index),
      );
    }

    return SizedBox(
      height: 95,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) => buildItem(index),
      ),
    );
  }
}
